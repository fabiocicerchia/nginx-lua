#!/bin/bash
# Verify Docker image signature and SBOM attestation before use
# This script should be used by consumers to verify image integrity
# Ref: Cyber Resilience Act - downstream verification requirement
set -euo pipefail

IMAGE_REF="$1"

if [ -z "$IMAGE_REF" ]; then
    echo "Usage: $0 <image-reference>"
    echo "Example: $0 fabiocicerchia/nginx-lua:latest"
    exit 1
fi

if ! command -v cosign &> /dev/null; then
    echo "ERROR: cosign is not installed. Install from https://github.com/sigstore/cosign"
    exit 1
fi

# Locate cosign.pub relative to script or allow override
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COSIGN_PUB="${COSIGN_PUBLIC_KEY:-${SCRIPT_DIR}/../cosign.pub}"

if [ ! -f "$COSIGN_PUB" ]; then
    echo "ERROR: Public key not found at ${COSIGN_PUB}"
    echo "Download it from: https://github.com/fabiocicerchia/nginx-lua/blob/main/cosign.pub"
    exit 1
fi

echo "=== Verifying image signature: ${IMAGE_REF} ==="
echo "Using public key: ${COSIGN_PUB}"

cosign verify --key "$COSIGN_PUB" "$IMAGE_REF"
echo "PASS: Image signature verified"

echo ""
echo "=== Verifying SBOM attestation ==="

if cosign verify-attestation \
    --key "$COSIGN_PUB" \
    --type cyclonedx \
    "$IMAGE_REF"; then
    echo "PASS: CycloneDX SBOM attestation verified"
else
    echo "WARN: No CycloneDX SBOM attestation found"
fi

echo ""
echo "=== Image ${IMAGE_REF} verification complete ==="
