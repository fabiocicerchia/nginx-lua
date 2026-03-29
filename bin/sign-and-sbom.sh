#!/bin/bash
# Sign Docker images with cosign (keyless OIDC) and generate signed SBOM
# Ref: Cyber Resilience Act Article 47 - SBOM requirement
# Ref: NIS2 Article 21(2)(d) - supply chain security
# Ref: https://github.com/CircleCI-Public/sign-and-publish-examples
set -euo pipefail

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

# Get the image digest for immutable reference
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' "$IMAGE_REF" 2>/dev/null || \
    docker inspect --format='{{.Id}}' "$IMAGE_REF")
echo "Image digest: ${DIGEST}"

# --- Signing key selection ---
# Prefer keyless OIDC signing (official CircleCI approach).  Fall back to
# key-based signing when COSIGN_KEY is explicitly provided (local / non-OIDC
# environments).
if [ -z "${COSIGN_KEY:-}" ]; then
    # Keyless: obtain an OIDC token from CircleCI and let Sigstore Fulcio
    # issue a short-lived signing certificate.
    if ! command -v circleci &> /dev/null; then
        echo "ERROR: circleci CLI is not installed (required for OIDC keyless signing)"
        echo "  Alternatively, set COSIGN_KEY to a PEM-encoded private key"
        exit 1
    fi
    echo "Using keyless OIDC signing via CircleCI"
    export SIGSTORE_ID_TOKEN
    SIGSTORE_ID_TOKEN=$(circleci run oidc get --claims '{"aud": "sigstore"}')
    COSIGN_SIGN_ARGS=(--yes)
    COSIGN_ATTEST_ARGS=(--yes)
else
    echo "Using key-based signing"
    # Materialise the inline PEM key into a temporary file so cosign can read
    # it reliably.  CI secrets often store multi-line values with literal \n.
    COSIGN_KEY_FILE=$(mktemp /tmp/cosign-key-XXXXXX.pem)
    trap 'rm -f "$COSIGN_KEY_FILE"' EXIT
    chmod 600 "$COSIGN_KEY_FILE"
    printf '%s' "$COSIGN_KEY" | sed -e 's/\\n/\n/g' -e 's/\\r//g' > "$COSIGN_KEY_FILE"

    if ! grep -q -- '-----BEGIN' "$COSIGN_KEY_FILE"; then
        printf '%s' "$COSIGN_KEY" | base64 -d > "$COSIGN_KEY_FILE" 2>/dev/null || true
    fi
    if ! grep -q -- '-----BEGIN' "$COSIGN_KEY_FILE"; then
        echo "ERROR: COSIGN_KEY does not contain a valid PEM block"
        echo "  Expected a PEM-encoded private key (-----BEGIN ... PRIVATE KEY-----)"
        exit 1
    fi

    export COSIGN_PASSWORD="${COSIGN_PASSWORD:-}"
    COSIGN_SIGN_ARGS=(--key "$COSIGN_KEY_FILE" --yes)
    COSIGN_ATTEST_ARGS=(--key "$COSIGN_KEY_FILE" --yes)
fi

# Sign the image by digest for an immutable, deterministic reference.
cosign sign \
    "${COSIGN_SIGN_ARGS[@]}" \
    -a "repo=fabiocicerchia/nginx-lua" \
    -a "build_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    -a "vcs_ref=${VCS_REF}" \
    -a "pipeline=circleci" \
    "$DIGEST"

echo "=== Image signed successfully ==="

# Generate SBOM in CycloneDX format (CRA-compliant)
SBOM_FILE="/tmp/sbom-${IMAGE_REF_PATH}.cdx.json"
echo "=== Generating SBOM: ${SBOM_FILE} ==="

syft "$IMAGE_REF" \
    --output cyclonedx-json="$SBOM_FILE" \
    --source-name "fabiocicerchia/nginx-lua" \
    --source-version "${VCS_REF}"

echo "=== SBOM generated ==="

# Attach SBOM to the image as an attestation (signed)
echo "=== Attaching signed SBOM attestation ==="

cosign attest \
    "${COSIGN_ATTEST_ARGS[@]}" \
    --predicate "$SBOM_FILE" \
    --type cyclonedx \
    "$DIGEST"

echo "=== Signed SBOM attestation attached ==="

# Also generate SPDX format for broader compatibility
SPDX_FILE="/tmp/sbom-${IMAGE_REF_PATH}.spdx.json"
syft "$IMAGE_REF" \
    --output spdx-json="$SPDX_FILE" \
    --source-name "fabiocicerchia/nginx-lua" \
    --source-version "${VCS_REF}"

echo "=== SPDX SBOM also generated at ${SPDX_FILE} ==="

# Verify the signature we just created
echo "=== Verifying signature ==="

if [ -z "${COSIGN_KEY:-}" ]; then
    # Keyless: verify via certificate identity
    OIDC_ISSUER="https://oidc.circleci.com/org/${CIRCLE_ORGANIZATION_ID}"
    CERT_IDENTITY="https://circleci.com/api/v2/projects/${CIRCLE_PROJECT_ID}/pipeline-definitions/${PIPELINE_DEFINITION_ID}"
    cosign verify \
        --certificate-oidc-issuer "$OIDC_ISSUER" \
        --certificate-identity "$CERT_IDENTITY" \
        "$DIGEST"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    COSIGN_PUB="${SCRIPT_DIR}/../cosign.pub"
    cosign verify --key "$COSIGN_PUB" "$DIGEST"
fi

echo "=== Verification successful ==="
echo "Image ${DIGEST} is signed, SBOM attached and verified."
