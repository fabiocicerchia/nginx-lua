#!/bin/bash
# Verify Docker image signature and SBOM attestation before use
# This script should be used by consumers to verify image integrity
# Ref: Cyber Resilience Act - downstream verification requirement
#
# Uses keyless verification via Sigstore certificate identity (Fulcio + Rekor).
set -euo pipefail

OIDC_ISSUER="https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c"
CERT_IDENTITY_REGEXP="https://circleci\\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*"

IMAGE_REF="${1:-}"

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

cosign verify \
    --certificate-oidc-issuer "$OIDC_ISSUER" \
    --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
    "$IMAGE_REF"
echo "PASS: Image signature verified"

echo ""
echo "=== Verifying SBOM attestation ==="

if cosign verify-attestation \
    --certificate-oidc-issuer "$OIDC_ISSUER" \
    --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
    --type cyclonedx \
    "$IMAGE_REF"; then
    echo "PASS: CycloneDX SBOM attestation verified"
else
    echo "WARN: No CycloneDX SBOM attestation found"
fi

echo ""
echo "=== Image ${IMAGE_REF} verification complete ==="
