#!/bin/bash
# Sign Docker images with cosign and generate signed SBOM
# Ref: Cyber Resilience Act Article 47 - SBOM requirement
# Ref: NIS2 Article 21(2)(d) - supply chain security
set -euo pipefail

IMAGE_REF="$1"

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

# Verify required environment variables for keyless signing
if [ -z "${COSIGN_EXPERIMENTAL:-}" ] && [ -z "${COSIGN_KEY:-}" ]; then
    echo "ERROR: Either COSIGN_EXPERIMENTAL=1 (keyless) or COSIGN_KEY must be set"
    exit 1
fi

echo "=== Signing image: ${IMAGE_REF} ==="

# Get the image digest for immutable reference
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' "$IMAGE_REF" 2>/dev/null || \
    docker inspect --format='{{.Id}}' "$IMAGE_REF")
echo "Image digest: ${DIGEST}"

# Sign the image
if [ -n "${COSIGN_KEY:-}" ]; then
    # Key-based signing
    cosign sign --key "$COSIGN_KEY" \
        -a "repo=fabiocicerchia/nginx-lua" \
        -a "build_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        -a "vcs_ref=${VCS_REF:-$(git rev-parse --short HEAD)}" \
        -a "pipeline=circleci" \
        --yes \
        "$IMAGE_REF"
else
    # Keyless signing (Sigstore/Fulcio) - requires OIDC
    COSIGN_EXPERIMENTAL=1 cosign sign \
        -a "repo=fabiocicerchia/nginx-lua" \
        -a "build_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        -a "vcs_ref=${VCS_REF:-$(git rev-parse --short HEAD)}" \
        -a "pipeline=circleci" \
        --yes \
        "$IMAGE_REF"
fi

echo "=== Image signed successfully ==="

# Generate SBOM in CycloneDX format (CRA-compliant)
SBOM_FILE="/tmp/sbom-$(echo "$IMAGE_REF" | tr '/:' '-').cdx.json"
echo "=== Generating SBOM: ${SBOM_FILE} ==="

syft "$IMAGE_REF" \
    --output cyclonedx-json="$SBOM_FILE" \
    --source-name "fabiocicerchia/nginx-lua" \
    --source-version "${VCS_REF:-$(git rev-parse --short HEAD)}"

echo "=== SBOM generated ==="

# Attach SBOM to the image as an attestation (signed)
echo "=== Attaching signed SBOM attestation ==="

if [ -n "${COSIGN_KEY:-}" ]; then
    cosign attest --key "$COSIGN_KEY" \
        --predicate "$SBOM_FILE" \
        --type cyclonedx \
        --yes \
        "$IMAGE_REF"
else
    COSIGN_EXPERIMENTAL=1 cosign attest \
        --predicate "$SBOM_FILE" \
        --type cyclonedx \
        --yes \
        "$IMAGE_REF"
fi

echo "=== Signed SBOM attestation attached ==="

# Also generate SPDX format for broader compatibility
SPDX_FILE="/tmp/sbom-$(echo "$IMAGE_REF" | tr '/:' '-').spdx.json"
syft "$IMAGE_REF" \
    --output spdx-json="$SPDX_FILE" \
    --source-name "fabiocicerchia/nginx-lua" \
    --source-version "${VCS_REF:-$(git rev-parse --short HEAD)}"

echo "=== SPDX SBOM also generated at ${SPDX_FILE} ==="

# Verify the signature we just created
echo "=== Verifying signature ==="
if [ -n "${COSIGN_KEY:-}" ]; then
    cosign verify --key "${COSIGN_PUBLIC_KEY:-${COSIGN_KEY%.key}.pub}" "$IMAGE_REF"
else
    COSIGN_EXPERIMENTAL=1 cosign verify "$IMAGE_REF"
fi

echo "=== Verification successful ==="
echo "Image ${IMAGE_REF} is signed, SBOM attached and verified."
