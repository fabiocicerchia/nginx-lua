#!/bin/bash
# Sign Docker images with cosign (keyless OIDC) and generate signed SBOM
# Ref: Cyber Resilience Act Article 47 - SBOM requirement
# Ref: NIS2 Article 21(2)(d) - supply chain security
# Ref: https://github.com/CircleCI-Public/sign-and-publish-examples
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
    exit 1
fi

# Verify required tools
for tool in cosign syft; do
    if ! command -v "$tool" &> /dev/null; then
        echo "ERROR: $tool is not installed"
        exit 1
    fi
done

echo "=== Signing image: ${IMAGE_REF} ==="

# Get the image digest for immutable reference.
# RepoDigests returns "image@sha256:…" which cosign needs.  The image MUST
# exist in a registry before signing because cosign attaches signatures as
# OCI artifacts alongside the image.
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' "$IMAGE_REF" 2>/dev/null || true)
if [ -z "$DIGEST" ]; then
    echo "ERROR: No RepoDigests found for ${IMAGE_REF}"
    echo "  The image must be pushed to a registry before signing."
    echo "  cosign attaches signatures as OCI artifacts and cannot sign local-only images."
    exit 1
fi
echo "Image digest: ${DIGEST}"

# Keyless OIDC signing: obtain an OIDC token from CircleCI and let Sigstore
# Fulcio issue a short-lived signing certificate.
if ! command -v circleci &> /dev/null; then
    echo "ERROR: circleci CLI is not installed (required for OIDC keyless signing)"
    exit 1
fi
echo "Using keyless OIDC signing via CircleCI"
export SIGSTORE_ID_TOKEN
SIGSTORE_ID_TOKEN=$(circleci run oidc get --claims '{"aud": "sigstore"}')

# Sign the image by digest for an immutable, deterministic reference.
retry_on_rate_limit cosign sign \
    --yes \
    -a "repo=fabiocicerchia/nginx-lua" \
    -a "build_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    -a "vcs_ref=${VCS_REF}" \
    -a "pipeline=circleci" \
    "$DIGEST"

echo "=== Image signed successfully ==="

# Generate SBOM in both CycloneDX and SPDX formats in a single syft run
# to avoid pulling image layers from the registry twice.
SBOM_FILE="/tmp/sbom-${IMAGE_REF_PATH}.cdx.json"
SPDX_FILE="/tmp/sbom-${IMAGE_REF_PATH}.spdx.json"
echo "=== Generating SBOMs: ${SBOM_FILE} + ${SPDX_FILE} ==="

retry_on_rate_limit syft "$IMAGE_REF" \
    --output cyclonedx-json="$SBOM_FILE" \
    --output spdx-json="$SPDX_FILE" \
    --source-name "fabiocicerchia/nginx-lua" \
    --source-version "${VCS_REF}"

echo "=== SBOMs generated ==="

# Attach SBOM to the image as an attestation (signed)
echo "=== Attaching signed SBOM attestation ==="

retry_on_rate_limit cosign attest \
    --yes \
    --predicate "$SBOM_FILE" \
    --type cyclonedx \
    "$DIGEST"

echo "=== Signed SBOM attestation attached ==="

# Verify the signature we just created
echo "=== Verifying signature ==="

OIDC_ISSUER="https://oidc.circleci.com/org/${CIRCLE_ORGANIZATION_ID}"
CERT_IDENTITY_REGEXP="https://circleci\\.com/api/v2/projects/${CIRCLE_PROJECT_ID}/pipeline-definitions/.*"
retry_on_rate_limit cosign verify \
    --certificate-oidc-issuer "$OIDC_ISSUER" \
    --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
    "$DIGEST"

echo "=== Verification successful ==="
echo "Image ${DIGEST} is signed, SBOM attached and verified."
