#!/bin/bash
# Sign a multi-arch manifest list (index) with cosign (keyless OIDC) and
# attach per-platform CycloneDX SBOM attestations to the index digest.
#
# This script runs after `docker manifest push` has published the index.
# It is the counterpart to bin/sign-image.sh:
#
#   * bin/sign-image.sh    — signs each per-arch image right after its
#                            `docker push` (runs in the per-arch CI jobs).
#   * bin/sign-manifest.sh — signs the multi-arch index after the manifest
#                            list has been pushed (runs in the bundle job).
#
# Per-arch images already have their own signatures and SBOM attestations
# attached (done by sign-image.sh at push time), so this script only deals
# with the index digest.  Per-platform SBOMs are still attached to the
# index so that tag-based consumers (who resolve through the manifest list)
# can retrieve an SBOM via the index tag.
#
# Resolves the index digest from the registry via `docker buildx imagetools
# inspect --raw` so it matches the bytes the registry actually stores.
# Ref: Cyber Resilience Act Article 47 - SBOM requirement
# Ref: NIS2 Article 21(2)(d) - supply chain security
set -euo pipefail

# Retry a command with exponential backoff on Docker rate-limit errors (HTTP 429 / TOOMANYREQUESTS).
retry_on_rate_limit() {
    local max_retries="${SIGN_MAX_RETRIES:-4}"
    local delay=2
    local attempt=0
    local output_file
    output_file=$(mktemp /tmp/retry-output-XXXXXX)
    while true; do
        local rc=0
        "$@" > "$output_file" 2>&1 || rc=$?
        if [ $rc -eq 0 ]; then
            cat "$output_file"
            rm -f "$output_file"
            return 0
        fi
        if grep -qi "TOOMANYREQUESTS\|rate limit\|429" "$output_file" && [ $attempt -lt "$max_retries" ]; then
            attempt=$((attempt + 1))
            echo "Rate limited – retrying in ${delay}s (attempt ${attempt}/${max_retries})…"
            sleep $delay
            delay=$((delay * 2))
        else
            cat "$output_file"
            rm -f "$output_file"
            return $rc
        fi
    done
}

IMAGE_REF="$1"
VCS_REF=${VCS_REF:-$(git rev-parse --short HEAD)}
IMAGE_REF_PATH=$(echo "$IMAGE_REF" | tr '/:' '-')

if [ -z "$IMAGE_REF" ]; then
    echo "Usage: $0 <image-reference>"
    echo "Example: $0 fabiocicerchia/nginx-lua:1.29.7-alpine"
    exit 1
fi

# Verify required tools
for tool in cosign jq; do
    if ! command -v "$tool" &> /dev/null; then
        echo "ERROR: $tool is not installed"
        exit 1
    fi
done

REPO="${IMAGE_REF%%:*}"

# ─────────────────────────────────────────────────────────────────────────────
# Resolve the manifest list (index) digest
# ─────────────────────────────────────────────────────────────────────────────
echo "=== Resolving manifest list digest: ${IMAGE_REF} ==="

# Use --raw to get the exact bytes stored in the registry so the digest
# matches what the registry returns (docker manifest inspect reformats JSON,
# producing a different hash).
MANIFEST_RAW_FILE=$(mktemp /tmp/manifest-raw-XXXXXX)
trap 'rm -f "$MANIFEST_RAW_FILE"' EXIT

if ! docker buildx imagetools inspect "$IMAGE_REF" --raw > "$MANIFEST_RAW_FILE" 2>/dev/null; then
    echo "ERROR: Cannot resolve manifest for ${IMAGE_REF}"
    echo "  Ensure docker CLI with buildx is available and the image exists in the registry."
    exit 1
fi

INDEX_RAW=$(sha256sum "$MANIFEST_RAW_FILE" | awk '{print $1}')
INDEX_DIGEST="${REPO}@sha256:${INDEX_RAW}"
echo "Index digest: ${INDEX_DIGEST}"

# Extract the list of per-arch platforms the index covers.  We only use
# these to drive per-platform SBOM generation — per-arch signatures are
# already attached by bin/sign-image.sh and are not re-applied here.
PLATFORMS=$(jq -r '.manifests[] | select(.platform.os=="linux") | "\(.platform.os)/\(.platform.architecture)"' "$MANIFEST_RAW_FILE")
if [ -z "$PLATFORMS" ]; then
    echo "ERROR: No linux platforms found in manifest list"
    exit 1
fi
echo "Index covers platforms:"
echo "$PLATFORMS" | sed 's/^/  /'

rm -f "$MANIFEST_RAW_FILE"

# ─────────────────────────────────────────────────────────────────────────────
# Keyless OIDC signing via CircleCI
# ─────────────────────────────────────────────────────────────────────────────
if ! command -v circleci &> /dev/null; then
    echo "ERROR: circleci CLI is not installed (required for OIDC keyless signing)"
    exit 1
fi
echo "Using keyless OIDC signing via CircleCI"
export SIGSTORE_ID_TOKEN
SIGSTORE_ID_TOKEN=$(circleci run oidc get --claims '{"aud": "sigstore"}')

SIGN_ANNOTATIONS=(
    -a "repo=fabiocicerchia/nginx-lua"
    -a "build_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    -a "vcs_ref=${VCS_REF}"
    -a "pipeline=circleci"
)

# ─────────────────────────────────────────────────────────────────────────────
# 1. Sign the index (manifest list) image
# ─────────────────────────────────────────────────────────────────────────────
echo "=== Signing index image: ${INDEX_DIGEST} ==="
retry_on_rate_limit cosign sign \
    --yes \
    "${SIGN_ANNOTATIONS[@]}" \
    -a "type=manifest-list" \
    "$INDEX_DIGEST"
echo "=== Index image signed ==="

# ─────────────────────────────────────────────────────────────────────────────
# 2. Generate and attach per-platform SBOMs to the index
# ─────────────────────────────────────────────────────────────────────────────
if command -v syft &> /dev/null; then
    while IFS= read -r PLATFORM; do
        [ -z "$PLATFORM" ] && continue
        PLAT_LABEL=$(echo "$PLATFORM" | tr '/' '-')
        SBOM_FILE="/tmp/sbom-${IMAGE_REF_PATH}-${PLAT_LABEL}.cdx.json"

        echo "=== Generating SBOM for ${PLATFORM}: ${SBOM_FILE} ==="
        retry_on_rate_limit syft "$IMAGE_REF" \
            --platform "$PLATFORM" \
            --output cyclonedx-json="$SBOM_FILE" \
            --source-name "fabiocicerchia/nginx-lua@${PLATFORM}" \
            --source-version "${VCS_REF}"

        echo "=== Attaching SBOM attestation (${PLATFORM}) to index ==="
        retry_on_rate_limit cosign attest \
            --yes \
            --predicate "$SBOM_FILE" \
            --type cyclonedx \
            "$INDEX_DIGEST"

        echo "=== SBOM attached for ${PLATFORM} (index) ==="
        rm -f "$SBOM_FILE"
    done <<< "$PLATFORMS"
else
    echo "WARN: syft not installed, skipping SBOM generation"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 3. Verify the index signature
# ─────────────────────────────────────────────────────────────────────────────
OIDC_ISSUER="https://oidc.circleci.com/org/${CIRCLE_ORGANIZATION_ID}"
CERT_IDENTITY_REGEXP="https://circleci\\.com/api/v2/projects/${CIRCLE_PROJECT_ID}/pipeline-definitions/.*"

echo "=== Verifying index signature ==="
retry_on_rate_limit cosign verify \
    --certificate-oidc-issuer "$OIDC_ISSUER" \
    --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
    "$INDEX_DIGEST"

echo "=== Index signature verified ==="
echo "Signed: index ${INDEX_DIGEST}"
