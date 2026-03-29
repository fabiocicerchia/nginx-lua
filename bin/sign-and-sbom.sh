#!/bin/bash
# Sign Docker images with cosign and generate signed SBOM
# Ref: Cyber Resilience Act Article 47 - SBOM requirement
# Ref: NIS2 Article 21(2)(d) - supply chain security
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

# Require key-based signing.
# The keypair must be generated without a passphrase (COSIGN_PASSWORD="") so
# that signing works non-interactively in CI. Setting COSIGN_PASSWORD="" here
# ensures cosign never prompts even if the variable was unset in the environment.
if [ -z "${COSIGN_KEY:-}" ]; then
    echo "ERROR: COSIGN_KEY environment variable must be set to the private key content"
    echo "  Generate a passwordless keypair with: COSIGN_PASSWORD='' cosign generate-key-pair"
    echo "  Store the cosign.key content in the COSIGN_KEY CI secret"
    echo "  Commit cosign.pub to the repository"
    exit 1
fi
export COSIGN_PASSWORD="${COSIGN_PASSWORD:-}"

echo "=== Signing image: ${IMAGE_REF} ==="

# Get the image digest for immutable reference
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' "$IMAGE_REF" 2>/dev/null || \
    docker inspect --format='{{.Id}}' "$IMAGE_REF")
echo "Image digest: ${DIGEST}"

# Sign the image with key.
# CI systems (e.g. CircleCI) store multi-line secrets with literal \n instead
# of real newlines. printf '%b' normalises these into a child-process-scoped env
# var consumed via cosign's native env:// protocol — no disk I/O, no temp files,
# no /proc/self/fd entries; the normalised key exists only in cosign's memory.
COSIGN_KEY_NORMALIZED=$(printf '%b' "$COSIGN_KEY") \
cosign sign --key env://COSIGN_KEY_NORMALIZED \
    -a "repo=fabiocicerchia/nginx-lua" \
    -a "build_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    -a "vcs_ref=${VCS_REF}" \
    -a "pipeline=circleci" \
    --yes \
    "$IMAGE_REF"

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

COSIGN_KEY_NORMALIZED=$(printf '%b' "$COSIGN_KEY") \
cosign attest --key env://COSIGN_KEY_NORMALIZED \
    --predicate "$SBOM_FILE" \
    --type cyclonedx \
    --yes \
    "$IMAGE_REF"

echo "=== Signed SBOM attestation attached ==="

# Also generate SPDX format for broader compatibility
SPDX_FILE="/tmp/sbom-${IMAGE_REF_PATH}.spdx.json"
syft "$IMAGE_REF" \
    --output spdx-json="$SPDX_FILE" \
    --source-name "fabiocicerchia/nginx-lua" \
    --source-version "${VCS_REF}"

echo "=== SPDX SBOM also generated at ${SPDX_FILE} ==="

# Verify the signature we just created using the public key in the repo
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COSIGN_PUB="${SCRIPT_DIR}/../cosign.pub"

echo "=== Verifying signature with ${COSIGN_PUB} ==="
cosign verify --key "$COSIGN_PUB" "$IMAGE_REF"

echo "=== Verification successful ==="
echo "Image ${IMAGE_REF} is signed, SBOM attached and verified."
