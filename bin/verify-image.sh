#!/bin/bash
# Verify Docker image signature and SBOM attestation before use
# This script should be used by consumers to verify image integrity
# Ref: Cyber Resilience Act - downstream verification requirement
#
# Supports two verification modes:
#   1. Keyless (default): verifies via Sigstore certificate identity
#   2. Key-based: verifies with cosign.pub (set COSIGN_PUBLIC_KEY to enable)
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

# Determine verification mode
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COSIGN_PUB="${COSIGN_PUBLIC_KEY:-${SCRIPT_DIR}/../cosign.pub}"

if [ -n "${COSIGN_PUBLIC_KEY:-}" ] && [ -f "$COSIGN_PUB" ]; then
    # Key-based verification
    echo "Using key-based verification: ${COSIGN_PUB}"
    VERIFY_ARGS=(--key "$COSIGN_PUB")
    ATTEST_ARGS=(--key "$COSIGN_PUB")
else
    # Keyless verification via Sigstore certificate identity
    OIDC_ISSUER="${COSIGN_OIDC_ISSUER:-https://oidc.circleci.com/org/${CIRCLE_ORGANIZATION_ID:-}}"
    CERT_IDENTITY="${COSIGN_CERT_IDENTITY:-https://circleci.com/api/v2/projects/${CIRCLE_PROJECT_ID:-}/pipeline-definitions/${PIPELINE_DEFINITION_ID:-}}"

    if [ -z "${CIRCLE_ORGANIZATION_ID:-}" ] && [ -z "${COSIGN_OIDC_ISSUER:-}" ]; then
        echo "ERROR: Keyless verification requires OIDC issuer information"
        echo "  Set CIRCLE_ORGANIZATION_ID, CIRCLE_PROJECT_ID, and PIPELINE_DEFINITION_ID"
        echo "  Or set COSIGN_OIDC_ISSUER and COSIGN_CERT_IDENTITY directly"
        echo "  Or set COSIGN_PUBLIC_KEY to a local cosign.pub file for key-based verification"
        exit 1
    fi

    echo "Using keyless verification"
    echo "  OIDC issuer: ${OIDC_ISSUER}"
    echo "  Certificate identity: ${CERT_IDENTITY}"
    VERIFY_ARGS=(--certificate-oidc-issuer "$OIDC_ISSUER" --certificate-identity "$CERT_IDENTITY")
    ATTEST_ARGS=(--certificate-oidc-issuer "$OIDC_ISSUER" --certificate-identity "$CERT_IDENTITY")
fi

cosign verify "${VERIFY_ARGS[@]}" "$IMAGE_REF"
echo "PASS: Image signature verified"

echo ""
echo "=== Verifying SBOM attestation ==="

if cosign verify-attestation \
    "${ATTEST_ARGS[@]}" \
    --type cyclonedx \
    "$IMAGE_REF"; then
    echo "PASS: CycloneDX SBOM attestation verified"
else
    echo "WARN: No CycloneDX SBOM attestation found"
fi

echo ""
echo "=== Image ${IMAGE_REF} verification complete ==="
