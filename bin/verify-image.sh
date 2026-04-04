#!/bin/bash
# Verify Docker image signature and SBOM attestation before use
# This script should be used by consumers to verify image integrity
# Ref: Cyber Resilience Act - downstream verification requirement
#
# Signatures and SBOM attestations are attached to multi-arch index
# (manifest list) images, not to individual per-arch images.
# When you verify an index image, cosign resolves the correct entry
# based on the host architecture automatically.
#
# SBOM attestations are generated per-platform (linux/amd64, linux/arm64)
# and attached to the index digest.  You can filter the correct SBOM by
# checking the CycloneDX metadata.component.name field, which contains
# the platform identifier (e.g. "fabiocicerchia/nginx-lua@linux/amd64").
#
# Uses keyless verification via Sigstore certificate identity (Fulcio + Rekor).
set -euo pipefail

OIDC_ISSUER="https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c"
CERT_IDENTITY_REGEXP="https://circleci\\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*"

IMAGE_REF="${1:-}"

if [ -z "$IMAGE_REF" ]; then
    cat <<EOF
Usage: $0 <image-reference>

Verify the cosign signature and CycloneDX SBOM attestation on an
nginx-lua multi-arch index image.

Examples:
  $0 fabiocicerchia/nginx-lua:latest
  $0 fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3

What is verified:
  1. Keyless cosign signature on the index (manifest list) image
  2. CycloneDX SBOM attestation attached to the index digest

Note: Signatures are on the index image (multi-arch manifest list),
not on individual per-arch images.  Per-platform SBOMs are attached
to the same index digest; cosign resolves the correct attestation
for your host architecture automatically.

To inspect a specific platform's SBOM manually:
  cosign verify-attestation \\
    --certificate-oidc-issuer "$OIDC_ISSUER" \\
    --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \\
    --type cyclonedx \\
    <image-ref> | jq -r '.payload' | base64 -d | \\
    jq 'select(.predicate.metadata.component.name | contains("linux/amd64"))'
EOF
    exit 1
fi

if ! command -v cosign &> /dev/null; then
    echo "ERROR: cosign is not installed. Install from https://github.com/sigstore/cosign"
    exit 1
fi

echo "=== Verifying index image signature: ${IMAGE_REF} ==="

cosign verify \
    --certificate-oidc-issuer "$OIDC_ISSUER" \
    --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
    "$IMAGE_REF"
echo "PASS: Index image signature verified"

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
