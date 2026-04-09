#!/bin/bash
# Verify Docker image signature and SBOM attestation before use
# This script should be used by consumers to verify image integrity
# Ref: Cyber Resilience Act - downstream verification requirement
#
# Both the multi-arch index (manifest list) AND individual per-arch
# images are signed.  You can verify by tag or by sha256 digest.
#
# SBOM attestations are generated per-platform (linux/amd64, linux/arm64)
# and attached to both the index digest and the per-arch image digest.
# Each SBOM identifies its target platform via the CycloneDX
# metadata.component.name field (e.g. "fabiocicerchia/nginx-lua@linux/amd64").
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
nginx-lua image (by tag or by sha256 digest).

Examples:
  # Verify by tag (resolves to index/manifest list)
  $0 fabiocicerchia/nginx-lua:latest
  $0 fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3

  # Verify by digest (per-arch image)
  $0 fabiocicerchia/nginx-lua@sha256:abc123...

What is verified:
  1. Keyless cosign signature (works on both index and per-arch images)
  2. CycloneDX SBOM attestation

Both index (manifest list) images and individual per-arch images are
signed.  Per-platform SBOMs are attached to both, so verification
works regardless of whether you pull by tag or by digest.

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
