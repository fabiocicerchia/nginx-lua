#!/bin/bash
# Sign multi-arch manifest lists AND per-arch images with cosign (keyless OIDC)
# and attach platform-specific SBOMs.
#
# This script is used after `docker manifest push` to sign:
#   1. The index image (manifest list) — for tag-based consumers
#   2. Each per-arch image by digest — for digest-based consumers (sha256)
#
# Per-platform SBOMs are attached to BOTH the index digest and the matching
# per-arch image digest, so consumers always get the correct SBOM regardless
# of how they reference the image.
#
# Resolves digests from the registry via `docker manifest inspect`.
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

# Extract per-arch digests from the manifest list
AMD64_DIGEST=$(jq -r '.manifests[] | select(.platform.architecture=="amd64" and .platform.os=="linux") | .digest' "$MANIFEST_RAW_FILE")
ARM64_DIGEST=$(jq -r '.manifests[] | select(.platform.architecture=="arm64" and .platform.os=="linux") | .digest' "$MANIFEST_RAW_FILE")
rm -f "$MANIFEST_RAW_FILE"

echo "Per-arch digests:"
echo "  linux/amd64: ${AMD64_DIGEST}"
echo "  linux/arm64: ${ARM64_DIGEST}"

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
# 2. Sign each per-arch image by digest
# ─────────────────────────────────────────────────────────────────────────────
for ARCH_ENTRY in "amd64:${AMD64_DIGEST}" "arm64:${ARM64_DIGEST}"; do
    ARCH="${ARCH_ENTRY%%:*}"
    ARCH_DIGEST="${REPO}@${ARCH_ENTRY#*:}"
    echo "=== Signing per-arch image (${ARCH}): ${ARCH_DIGEST} ==="
    retry_on_rate_limit cosign sign \
        --yes \
        "${SIGN_ANNOTATIONS[@]}" \
        -a "type=per-arch" \
        -a "architecture=${ARCH}" \
        "$ARCH_DIGEST"
    echo "=== Per-arch image signed (${ARCH}) ==="
done

# ─────────────────────────────────────────────────────────────────────────────
# 3. Generate and attach per-platform SBOMs
# ─────────────────────────────────────────────────────────────────────────────
if command -v syft &> /dev/null; then
    for PLATFORM_ENTRY in "linux/amd64:${AMD64_DIGEST}" "linux/arm64:${ARM64_DIGEST}"; do
        PLATFORM="${PLATFORM_ENTRY%%:*}"
        ARCH_DIGEST="${REPO}@${PLATFORM_ENTRY#*:}"
        PLAT_LABEL=$(echo "$PLATFORM" | tr '/' '-')
        SBOM_FILE="/tmp/sbom-${IMAGE_REF_PATH}-${PLAT_LABEL}.cdx.json"

        echo "=== Generating SBOM for ${PLATFORM}: ${SBOM_FILE} ==="
        retry_on_rate_limit syft "$IMAGE_REF" \
            --platform "$PLATFORM" \
            --output cyclonedx-json="$SBOM_FILE" \
            --source-name "fabiocicerchia/nginx-lua@${PLATFORM}" \
            --source-version "${VCS_REF}"

        # Attach SBOM to the index image (for tag-based consumers)
        echo "=== Attaching SBOM attestation (${PLATFORM}) to index ==="
        retry_on_rate_limit cosign attest \
            --yes \
            --predicate "$SBOM_FILE" \
            --type cyclonedx \
            "$INDEX_DIGEST"

        # Attach the same SBOM to the per-arch image (for digest-based consumers)
        echo "=== Attaching SBOM attestation (${PLATFORM}) to per-arch image ==="
        retry_on_rate_limit cosign attest \
            --yes \
            --predicate "$SBOM_FILE" \
            --type cyclonedx \
            "$ARCH_DIGEST"

        echo "=== SBOM attached for ${PLATFORM} (index + per-arch) ==="
        rm -f "$SBOM_FILE"
    done
else
    echo "WARN: syft not installed, skipping SBOM generation"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 4. Verify signatures
# ─────────────────────────────────────────────────────────────────────────────
OIDC_ISSUER="https://oidc.circleci.com/org/${CIRCLE_ORGANIZATION_ID}"
CERT_IDENTITY_REGEXP="https://circleci\\.com/api/v2/projects/${CIRCLE_PROJECT_ID}/pipeline-definitions/.*"

echo "=== Verifying index signature ==="
retry_on_rate_limit cosign verify \
    --certificate-oidc-issuer "$OIDC_ISSUER" \
    --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
    "$INDEX_DIGEST"

for ARCH_ENTRY in "amd64:${AMD64_DIGEST}" "arm64:${ARM64_DIGEST}"; do
    ARCH="${ARCH_ENTRY%%:*}"
    ARCH_DIGEST="${REPO}@${ARCH_ENTRY#*:}"
    echo "=== Verifying per-arch signature (${ARCH}) ==="
    retry_on_rate_limit cosign verify \
        --certificate-oidc-issuer "$OIDC_ISSUER" \
        --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
        "$ARCH_DIGEST"
done

echo "=== All signatures verified ==="
echo "Signed: index ${INDEX_DIGEST}"
echo "Signed: amd64 ${REPO}@${AMD64_DIGEST}"
echo "Signed: arm64 ${REPO}@${ARM64_DIGEST}"
