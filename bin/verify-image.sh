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

echo "=== Verifying image signature: ${IMAGE_REF} ==="

# Verify with keyless (Sigstore transparency log)
if COSIGN_EXPERIMENTAL=1 cosign verify "$IMAGE_REF" 2>/dev/null; then
    echo "PASS: Image signature verified via Sigstore"
elif [ -n "${COSIGN_PUBLIC_KEY:-}" ]; then
    cosign verify --key "$COSIGN_PUBLIC_KEY" "$IMAGE_REF"
    echo "PASS: Image signature verified with public key"
else
    echo "FAIL: Could not verify image signature"
    exit 1
fi

echo ""
echo "=== Verifying SBOM attestation ==="

if COSIGN_EXPERIMENTAL=1 cosign verify-attestation \
    --type cyclonedx \
    "$IMAGE_REF" 2>/dev/null; then
    echo "PASS: CycloneDX SBOM attestation verified"
else
    echo "WARN: No CycloneDX SBOM attestation found"
fi

echo ""
echo "=== Image ${IMAGE_REF} verification complete ==="
