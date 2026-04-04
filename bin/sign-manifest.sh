#!/bin/bash
# Sign multi-arch manifest lists with cosign (keyless OIDC) and attach SBOM
# This script is used after `docker manifest push` to sign index images.
# Unlike sign-and-sbom.sh (which uses `docker inspect`), this resolves
# the digest from the registry via `skopeo` or `docker manifest inspect`.
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
for tool in cosign; do
    if ! command -v "$tool" &> /dev/null; then
        echo "ERROR: $tool is not installed"
        exit 1
    fi
done

echo "=== Signing manifest list: ${IMAGE_REF} ==="

# Resolve the manifest list digest from the registry.
# docker inspect won't work for manifest lists (they aren't local images).
REPO="${IMAGE_REF%%:*}"
DIGEST=""

if command -v skopeo &> /dev/null; then
    DIGEST=$(skopeo inspect --no-tags "docker://${IMAGE_REF}" 2>/dev/null \
        | python3 -c "import sys,json; print(json.load(sys.stdin).get('Digest',''))" || true)
    if [ -n "$DIGEST" ]; then
        DIGEST="${REPO}@${DIGEST}"
    fi
fi

if [ -z "$DIGEST" ]; then
    # Fallback: compute digest from the raw manifest
    RAW_DIGEST=$(docker manifest inspect "$IMAGE_REF" 2>/dev/null | sha256sum | awk '{print $1}')
    if [ -n "$RAW_DIGEST" ]; then
        DIGEST="${REPO}@sha256:${RAW_DIGEST}"
    fi
fi

if [ -z "$DIGEST" ]; then
    echo "ERROR: Cannot resolve digest for manifest list ${IMAGE_REF}"
    echo "  Ensure skopeo or docker CLI is available and the image exists in the registry."
    exit 1
fi

echo "Manifest list digest: ${DIGEST}"

# Keyless OIDC signing via CircleCI
if ! command -v circleci &> /dev/null; then
    echo "ERROR: circleci CLI is not installed (required for OIDC keyless signing)"
    exit 1
fi
echo "Using keyless OIDC signing via CircleCI"
export SIGSTORE_ID_TOKEN
SIGSTORE_ID_TOKEN=$(circleci run oidc get --claims '{"aud": "sigstore"}')

# Sign the manifest list by digest
retry_on_rate_limit cosign sign \
    --yes \
    -a "repo=fabiocicerchia/nginx-lua" \
    -a "build_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    -a "vcs_ref=${VCS_REF}" \
    -a "pipeline=circleci" \
    -a "type=manifest-list" \
    "$DIGEST"

echo "=== Manifest list signed successfully ==="

# Generate and attach SBOM if syft is available
if command -v syft &> /dev/null; then
    SBOM_FILE="/tmp/sbom-${IMAGE_REF_PATH}.cdx.json"
    echo "=== Generating SBOM: ${SBOM_FILE} ==="

    retry_on_rate_limit syft "$IMAGE_REF" \
        --output cyclonedx-json="$SBOM_FILE" \
        --source-name "fabiocicerchia/nginx-lua" \
        --source-version "${VCS_REF}"

    echo "=== Attaching signed SBOM attestation ==="
    retry_on_rate_limit cosign attest \
        --yes \
        --predicate "$SBOM_FILE" \
        --type cyclonedx \
        "$DIGEST"

    echo "=== Signed SBOM attestation attached ==="
    rm -f "$SBOM_FILE"
else
    echo "WARN: syft not installed, skipping SBOM generation"
fi

# Verify the signature
OIDC_ISSUER="https://oidc.circleci.com/org/${CIRCLE_ORGANIZATION_ID}"
CERT_IDENTITY_REGEXP="https://circleci\\.com/api/v2/projects/${CIRCLE_PROJECT_ID}/pipeline-definitions/.*"
retry_on_rate_limit cosign verify \
    --certificate-oidc-issuer "$OIDC_ISSUER" \
    --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
    "$DIGEST"

echo "=== Verification successful ==="
echo "Manifest list ${DIGEST} is signed and verified."
