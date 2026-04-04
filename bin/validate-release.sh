#!/bin/bash
# Validate a GitHub release for fabiocicerchia/nginx-lua
# Checks: Dockerfiles, packages, checksums, cosign signatures, OS consistency
set -euo pipefail

REPO="fabiocicerchia/nginx-lua"
TAG="${1:-}"
TMPDIR=""
PASS=0
FAIL=0
WARN=0

usage() {
    cat <<EOF
Usage: $(basename "$0") <release-tag>
Example: $(basename "$0") v1.20260404.160903

Validates:
  1. Stable + mainline Dockerfiles for all supported OS
  2. Default Dockerfile == mainline Alpine
  3. Packages for all OS (ARM + AMD)
  4. SHA256SUMS integrity and filename consistency
  5. Release files match tagged commit Dockerfiles
  6. Docker Hub image cosign signatures
  7. Docker Hub image OS version consistency with release

Prerequisites: curl, sha256sum, git, cosign (optional, for signature checks)
EOF
    exit 1
}

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }
warn() { WARN=$((WARN + 1)); echo "  WARN: $1"; }
section() { echo ""; echo "=== $1 ==="; }

cleanup() {
    if [ -n "$TMPDIR" ] && [ -d "$TMPDIR" ]; then
        rm -rf "$TMPDIR"
    fi
}
trap cleanup EXIT

download_asset() {
    local filename="$1"
    local dest="$2"
    local url="https://github.com/${REPO}/releases/download/${TAG}/${filename}"
    local http_code
    http_code=$(curl -sL -w "%{http_code}" -o "$dest" "$url")
    if [ "$http_code" = "200" ] && [ -s "$dest" ]; then
        return 0
    else
        return 1
    fi
}

if [ -z "$TAG" ]; then
    usage
fi

# Ensure we have the tag locally
git fetch origin --tags 2>/dev/null || true

if ! git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "ERROR: Tag $TAG not found in repository"
    exit 1
fi

# Read supported_versions from the tagged commit
SUPPORTED_VERSIONS=$(git show "$TAG:supported_versions" 2>/dev/null)
if [ -z "$SUPPORTED_VERSIONS" ]; then
    echo "ERROR: Cannot read supported_versions from tag $TAG"
    exit 1
fi

NGINX_MAINLINE=$(echo "$SUPPORTED_VERSIONS" | grep nginx_mainline | cut -d= -f2)
NGINX_STABLE=$(echo "$SUPPORTED_VERSIONS" | grep nginx_stable | cut -d= -f2)
DISTROS="almalinux alpine amazonlinux debian fedora ubuntu"

echo "Release validation for: $TAG"
echo "Nginx mainline: $NGINX_MAINLINE"
echo "Nginx stable:   $NGINX_STABLE"
echo "Supported OS:   $DISTROS"

# Create temp directory and download SHA256SUMS
TMPDIR=$(mktemp -d)
section "1. Download SHA256SUMS"

if download_asset "SHA256SUMS" "$TMPDIR/SHA256SUMS"; then
    pass "SHA256SUMS downloaded"
else
    fail "SHA256SUMS not found in release"
    echo "Cannot continue without SHA256SUMS"
    exit 1
fi

CHECKSUM_FILES=$(awk '{print $2}' "$TMPDIR/SHA256SUMS")

# ─────────────────────────────────────────────────────────────────────────────
section "2. Verify stable + mainline Dockerfiles for all OS"

for NGINX_VER in "$NGINX_MAINLINE" "$NGINX_STABLE"; do
    for DISTRO in $DISTROS; do
        # Determine expected OS version from supported_versions
        OS_VER=$(echo "$SUPPORTED_VERSIONS" | grep "^${DISTRO}=" | cut -d= -f2)
        EXPECTED_NAME="Dockerfile-nginx${NGINX_VER}-${DISTRO}${OS_VER}"

        # Check if a Dockerfile for this combo exists in SHA256SUMS (any OS version)
        FOUND=$(echo "$CHECKSUM_FILES" | grep "Dockerfile-nginx${NGINX_VER}-${DISTRO}" || true)
        if [ -n "$FOUND" ]; then
            pass "Dockerfile exists: nginx${NGINX_VER} ${DISTRO} (${FOUND})"
            # Check if the OS version matches the tagged commit
            if echo "$FOUND" | grep -q "$EXPECTED_NAME"; then
                pass "OS version matches tag: $EXPECTED_NAME"
            else
                fail "OS version mismatch: expected $EXPECTED_NAME, got $FOUND"
            fi
        else
            fail "Missing Dockerfile: nginx${NGINX_VER} ${DISTRO}"
        fi
    done
done

# ─────────────────────────────────────────────────────────────────────────────
section "3. Verify default Dockerfile == mainline Alpine"

ALPINE_VER=$(echo "$SUPPORTED_VERSIONS" | grep "^alpine=" | cut -d= -f2)
DEFAULT_HASH=$(grep "^[a-f0-9]\\+  Dockerfile$" "$TMPDIR/SHA256SUMS" | awk '{print $1}')
ALPINE_PATTERN="Dockerfile-nginx${NGINX_MAINLINE}-alpine"
ALPINE_HASH=$(grep "$ALPINE_PATTERN" "$TMPDIR/SHA256SUMS" | awk '{print $1}')

if [ -n "$DEFAULT_HASH" ] && [ -n "$ALPINE_HASH" ]; then
    if [ "$DEFAULT_HASH" = "$ALPINE_HASH" ]; then
        pass "Default Dockerfile SHA256 matches mainline Alpine ($DEFAULT_HASH)"
    else
        fail "Default Dockerfile ($DEFAULT_HASH) != mainline Alpine ($ALPINE_HASH)"
    fi
else
    fail "Cannot find default Dockerfile or mainline Alpine Dockerfile in SHA256SUMS"
fi

# ─────────────────────────────────────────────────────────────────────────────
section "4. Verify packages for all OS (ARM + AMD)"

EXPECTED_PACKAGES=()
for DISTRO in $DISTROS; do
    case "$DISTRO" in
        alpine)
            # Alpine APKs - check for both architectures (version-agnostic naming)
            for ARCH in amd64 arm64v8; do
                FOUND=$(echo "$CHECKSUM_FILES" | grep "\.apk" | grep "_${ARCH}" || true)
                if [ -n "$FOUND" ]; then
                    pass "Alpine APK ${ARCH}: $FOUND"
                else
                    fail "Missing Alpine APK for ${ARCH}"
                fi
            done
            ;;
        almalinux|amazonlinux|fedora)
            for NGINX_VER in "$NGINX_MAINLINE" "$NGINX_STABLE"; do
                SHORT_DISTRO="$DISTRO"
                [ "$DISTRO" = "amazonlinux" ] && SHORT_DISTRO="amzn"
                for ARCH in x86_64 aarch64; do
                    PATTERN="nginx-lua-${NGINX_VER}-.*${SHORT_DISTRO}.*${ARCH}\.rpm"
                    FOUND=$(echo "$CHECKSUM_FILES" | grep -E "$PATTERN" || true)
                    if [ -n "$FOUND" ]; then
                        pass "RPM nginx${NGINX_VER} ${DISTRO} ${ARCH}: $FOUND"
                    else
                        fail "Missing RPM: nginx${NGINX_VER} ${DISTRO} ${ARCH}"
                    fi
                done
            done
            ;;
        debian|ubuntu)
            DEB_DISTRO="$DISTRO"
            [ "$DISTRO" = "ubuntu" ] && DEB_DISTRO="noble"
            for NGINX_VER in "$NGINX_MAINLINE" "$NGINX_STABLE"; do
                for ARCH in amd64 arm64; do
                    PATTERN="nginx-lua_${NGINX_VER}-.*${DEB_DISTRO}_${ARCH}\.deb"
                    FOUND=$(echo "$CHECKSUM_FILES" | grep -E "$PATTERN" || true)
                    if [ -n "$FOUND" ]; then
                        pass "DEB nginx${NGINX_VER} ${DISTRO} ${ARCH}: $FOUND"
                    else
                        fail "Missing DEB: nginx${NGINX_VER} ${DISTRO} ${ARCH}"
                    fi
                done
            done
            ;;
    esac
done

# ─────────────────────────────────────────────────────────────────────────────
section "5. Download all assets and verify SHA256SUMS"

# Download all files listed in SHA256SUMS
DOWNLOAD_FAIL=0
while IFS='  ' read -r hash filename; do
    # Try both the exact name and with tilde replaced by dot (GitHub may rename)
    if download_asset "$filename" "$TMPDIR/$filename"; then
        : # OK
    else
        ALT_NAME=$(echo "$filename" | sed 's/~/./')
        if [ "$ALT_NAME" != "$filename" ] && download_asset "$ALT_NAME" "$TMPDIR/$filename"; then
            warn "Asset filename on GitHub uses '.' not '~': $ALT_NAME (SHA256SUMS says $filename)"
        else
            fail "Cannot download asset: $filename (also tried $ALT_NAME)"
            DOWNLOAD_FAIL=$((DOWNLOAD_FAIL + 1))
        fi
    fi
done < "$TMPDIR/SHA256SUMS"

# Verify checksums
cd "$TMPDIR"
CHECKSUM_OUTPUT=$(sha256sum -c SHA256SUMS 2>&1) || true
CHECKSUM_OK=$(echo "$CHECKSUM_OUTPUT" | grep -c ": OK$" || true)
CHECKSUM_FAIL=$(echo "$CHECKSUM_OUTPUT" | grep -c "FAILED$" || true)

if [ "$CHECKSUM_FAIL" -eq 0 ] && [ "$CHECKSUM_OK" -gt 0 ]; then
    pass "All $CHECKSUM_OK files pass SHA256 verification"
else
    fail "SHA256 verification: $CHECKSUM_OK OK, $CHECKSUM_FAIL FAILED"
    echo "$CHECKSUM_OUTPUT" | grep "FAILED" || true
fi
cd - >/dev/null

# Check for filename consistency (tilde vs dot)
TILDE_FILES=$(awk '{print $2}' "$TMPDIR/SHA256SUMS" | grep '~' || true)
if [ -n "$TILDE_FILES" ]; then
    for tf in $TILDE_FILES; do
        DOT_NAME=$(echo "$tf" | sed 's/~/./')
        # Check if the actual GitHub asset uses dot
        if curl -sI -o /dev/null -w "%{http_code}" "https://github.com/${REPO}/releases/download/${TAG}/${DOT_NAME}" 2>/dev/null | grep -q "302"; then
            fail "SHA256SUMS filename mismatch: lists '$tf' but GitHub asset is '$DOT_NAME'"
        fi
    done
fi

# ─────────────────────────────────────────────────────────────────────────────
section "6. Verify release Dockerfiles match tagged commit"

for NGINX_VER in "$NGINX_MAINLINE" "$NGINX_STABLE"; do
    for DISTRO in $DISTROS; do
        OS_VER=$(echo "$SUPPORTED_VERSIONS" | grep "^${DISTRO}=" | cut -d= -f2)
        REPO_DOCKERFILE="nginx/${NGINX_VER}/${DISTRO}/${OS_VER}/Dockerfile"
        REPO_HASH=$(git show "${TAG}:${REPO_DOCKERFILE}" 2>/dev/null | sha256sum | awk '{print $1}' || echo "NOT_FOUND")

        # Find the matching release Dockerfile hash
        RELEASE_HASH=$(grep "Dockerfile-nginx${NGINX_VER}-${DISTRO}" "$TMPDIR/SHA256SUMS" | awk '{print $1}' || echo "NOT_FOUND")

        if [ "$REPO_HASH" = "NOT_FOUND" ]; then
            fail "Dockerfile not in repo at tag: $REPO_DOCKERFILE"
        elif [ "$RELEASE_HASH" = "NOT_FOUND" ]; then
            fail "Dockerfile not in release: nginx${NGINX_VER}-${DISTRO}"
        elif [ "$REPO_HASH" = "$RELEASE_HASH" ]; then
            pass "Content match: $REPO_DOCKERFILE"
        else
            fail "Content mismatch: $REPO_DOCKERFILE (repo=$REPO_HASH, release=$RELEASE_HASH)"
        fi
    done
done

# ─────────────────────────────────────────────────────────────────────────────
section "7. Verify Docker Hub image signatures (cosign on index images)"

if ! command -v cosign &>/dev/null; then
    warn "cosign not installed - skipping Docker Hub signature verification"
    warn "Install cosign from https://github.com/sigstore/cosign to enable this check"
else
    OIDC_ISSUER="https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c"
    CERT_IDENTITY_REGEXP="https://circleci\\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*"

    # Verify cosign signatures on multi-arch index images (not arch-specific tags)
    for NGINX_VER in "$NGINX_MAINLINE" "$NGINX_STABLE"; do
        for DISTRO in $DISTROS; do
            OS_VER=$(echo "$SUPPORTED_VERSIONS" | grep "^${DISTRO}=" | cut -d= -f2)
            # Use the index (multi-arch) image for signature verification
            IMAGE_REF="fabiocicerchia/nginx-lua:${NGINX_VER}-${DISTRO}${OS_VER}"

            echo "  Checking signature on index image: $IMAGE_REF"
            if cosign verify \
                --certificate-oidc-issuer "$OIDC_ISSUER" \
                --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
                "$IMAGE_REF" >/dev/null 2>&1; then
                pass "Signature verified: $IMAGE_REF"
            else
                # Try without OS version (short tag)
                SHORT_REF="fabiocicerchia/nginx-lua:${NGINX_VER}-${DISTRO}"
                if cosign verify \
                    --certificate-oidc-issuer "$OIDC_ISSUER" \
                    --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
                    "$SHORT_REF" >/dev/null 2>&1; then
                    pass "Signature verified (short tag): $SHORT_REF"
                else
                    fail "Signature verification failed: $IMAGE_REF"
                fi
            fi
        done
    done

    # Verify SBOM attestation on a representative index image
    SAMPLE_IMAGE="fabiocicerchia/nginx-lua:${NGINX_MAINLINE}-alpine"
    echo "  Checking SBOM attestation: $SAMPLE_IMAGE"
    if cosign verify-attestation \
        --certificate-oidc-issuer "$OIDC_ISSUER" \
        --certificate-identity-regexp "$CERT_IDENTITY_REGEXP" \
        --type cyclonedx \
        "$SAMPLE_IMAGE" >/dev/null 2>&1; then
        pass "CycloneDX SBOM attestation verified: $SAMPLE_IMAGE"
    else
        warn "CycloneDX SBOM attestation not found: $SAMPLE_IMAGE"
    fi
fi

# ─────────────────────────────────────────────────────────────────────────────
section "8. Verify Docker Hub multi-arch images and tag consistency"

HAS_SKOPEO=false
if command -v skopeo &>/dev/null; then
    HAS_SKOPEO=true
fi
HAS_DOCKER=false
if command -v docker &>/dev/null; then
    HAS_DOCKER=true
fi

echo "  Checking Docker Hub tags match release OS versions..."
for NGINX_VER in "$NGINX_MAINLINE" "$NGINX_STABLE"; do
    for DISTRO in $DISTROS; do
        OS_VER=$(echo "$SUPPORTED_VERSIONS" | grep "^${DISTRO}=" | cut -d= -f2)
        TAG_NAME="${NGINX_VER}-${DISTRO}${OS_VER}"

        # Check Docker Hub API for the index tag
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
            "https://hub.docker.com/v2/repositories/fabiocicerchia/nginx-lua/tags/${TAG_NAME}")

        if [ "$HTTP_CODE" = "200" ]; then
            pass "Docker Hub tag exists: $TAG_NAME"
        else
            fail "Docker Hub tag missing: $TAG_NAME (HTTP $HTTP_CODE)"
        fi

        # Verify multi-arch support by inspecting the manifest (pull for specific arch)
        if $HAS_SKOPEO; then
            MANIFEST=$(skopeo inspect --raw "docker://fabiocicerchia/nginx-lua:${TAG_NAME}" 2>/dev/null || true)
            if echo "$MANIFEST" | grep -q "manifests"; then
                HAS_AMD64=$(echo "$MANIFEST" | grep -c '"amd64"' || true)
                HAS_ARM64=$(echo "$MANIFEST" | grep -c '"arm64"' || true)
                if [ "$HAS_AMD64" -gt 0 ] && [ "$HAS_ARM64" -gt 0 ]; then
                    pass "Multi-arch manifest (amd64+arm64): $TAG_NAME"
                else
                    fail "Missing arch in manifest: $TAG_NAME (amd64=$HAS_AMD64, arm64=$HAS_ARM64)"
                fi
            else
                warn "Not a multi-arch manifest: $TAG_NAME"
            fi
        elif $HAS_DOCKER; then
            MANIFEST=$(docker manifest inspect "fabiocicerchia/nginx-lua:${TAG_NAME}" 2>/dev/null || true)
            if [ -n "$MANIFEST" ]; then
                HAS_AMD64=$(echo "$MANIFEST" | grep -c '"amd64"' || true)
                HAS_ARM64=$(echo "$MANIFEST" | grep -c '"arm64"' || true)
                if [ "$HAS_AMD64" -gt 0 ] && [ "$HAS_ARM64" -gt 0 ]; then
                    pass "Multi-arch manifest (amd64+arm64): $TAG_NAME"
                else
                    fail "Missing arch in manifest: $TAG_NAME (amd64=$HAS_AMD64, arm64=$HAS_ARM64)"
                fi
            fi
        else
            warn "Neither skopeo nor docker available - cannot verify multi-arch manifests"
        fi

        # Check that release Dockerfile OS version matches Docker Hub tag OS version
        RELEASE_DOCKERFILE=$(echo "$CHECKSUM_FILES" | grep "Dockerfile-nginx${NGINX_VER}-${DISTRO}" || true)
        if [ -n "$RELEASE_DOCKERFILE" ]; then
            # Extract OS version from release filename
            RELEASE_OS=$(echo "$RELEASE_DOCKERFILE" | sed "s/Dockerfile-nginx${NGINX_VER}-${DISTRO}//")
            if [ "$RELEASE_OS" = "$OS_VER" ]; then
                pass "Release/DockerHub OS version consistent: ${DISTRO}${OS_VER}"
            else
                fail "Release has ${DISTRO}${RELEASE_OS} but Docker Hub/repo has ${DISTRO}${OS_VER}"
            fi
        fi
    done
done

# ─────────────────────────────────────────────────────────────────────────────
section "SUMMARY"
echo ""
echo "  PASS: $PASS"
echo "  FAIL: $FAIL"
echo "  WARN: $WARN"
echo ""

if [ "$FAIL" -gt 0 ]; then
    echo "RESULT: FAILED - $FAIL issue(s) found"
    exit 1
elif [ "$WARN" -gt 0 ]; then
    echo "RESULT: PASSED with $WARN warning(s)"
    exit 0
else
    echo "RESULT: ALL CHECKS PASSED"
    exit 0
fi
