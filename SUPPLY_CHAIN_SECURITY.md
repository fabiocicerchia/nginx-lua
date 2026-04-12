# Supply Chain Security Policy

This document describes the supply chain security measures implemented in the
nginx-lua project, in accordance with the **EU Cyber Resilience Act (CRA)**,
**NIS2 Directive**, and supply chain security best practices.

## Image Signing (Sigstore/Cosign)

All multi-arch Docker images (manifest lists) published to Docker Hub are
cryptographically signed using [cosign](https://github.com/sigstore/cosign)
(Sigstore project) with **keyless OIDC signing** via CircleCI and
[Sigstore Fulcio](https://docs.sigstore.dev/certificate_authority/overview/).

Both the **index image** (multi-arch manifest list) and each **per-arch image**
are signed individually.  This means consumers can verify signatures whether
they pull by tag (which resolves to the index) or by sha256 digest (which
resolves to a specific architecture image).

### When signing happens

The pipeline follows the standard Sigstore workflow of **push → sign by
digest**.  Cosign stores signatures as OCI artifacts alongside the image
in the registry (referenced by content digest), so the image must already
exist in the registry before it can be signed.

1. **Per-arch images** are signed *immediately after* their `docker push`
   in the same CI job that built them (`Docker AMD` / `Docker ARM`).  The
   signature and CycloneDX SBOM attestation are attached to the per-arch
   content digest as soon as the push completes — there is no window in
   which an unsigned per-arch image is available on Docker Hub before its
   signature is recorded.
2. **The multi-arch index** (manifest list) is signed *immediately after*
   `docker manifest push` in the `Docker Bundle` job.  Per-platform SBOMs
   are attached to the index digest so tag-based consumers can retrieve
   an SBOM through the index tag.

Instead of a static key pair, each CI run obtains a short-lived signing
certificate from Fulcio, authenticated by CircleCI's OIDC identity token.
The signing event is recorded in Sigstore's public [Rekor](https://docs.sigstore.dev/logging/overview/)
transparency log, providing a tamper-proof audit trail.

### Verifying Image Signatures

Before using any image, verify its signature to ensure it was published by
this project and has not been tampered with.

#### Prerequisites

Install cosign (v2+):

```bash
# macOS
brew install cosign

# Linux (amd64)
curl -sLO https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64
chmod +x cosign-linux-amd64
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
```

#### Verify an image

```bash
cosign verify \
  --certificate-oidc-issuer "https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c" \
  --certificate-identity-regexp "https://circleci\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*" \
  fabiocicerchia/nginx-lua:latest

# If verification succeeds, you'll see the signed payload.
# If it fails, DO NOT use the image.
```

#### Verify with a specific tag

```bash
cosign verify \
  --certificate-oidc-issuer "https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c" \
  --certificate-identity-regexp "https://circleci\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*" \
  fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3
```

#### Verify by digest (per-arch image)

```bash
# If you pull by sha256 digest for extra security, the per-arch image is also signed
cosign verify \
  --certificate-oidc-issuer "https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c" \
  --certificate-identity-regexp "https://circleci\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*" \
  fabiocicerchia/nginx-lua@sha256:<digest>
```

#### Verify using the included script

If you have cloned this repository:

```bash
./bin/verify-image.sh fabiocicerchia/nginx-lua:latest
```

This script verifies both the image signature and the SBOM attestation.

#### Integrate verification into your CI/CD

```bash
# Example: verify before deploying
cosign verify \
  --certificate-oidc-issuer "https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c" \
  --certificate-identity-regexp "https://circleci\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*" \
  fabiocicerchia/nginx-lua:latest > /dev/null 2>&1 \
  && docker pull fabiocicerchia/nginx-lua:latest \
  || { echo "ERROR: Image signature verification failed. Aborting."; exit 1; }
```

#### Integrate verification into Docker Compose

```yaml
# docker-compose.yml
services:
  web:
    image: fabiocicerchia/nginx-lua:latest
    # Verify before starting (init container pattern)
    depends_on:
      verify-image:
        condition: service_completed_successfully
  verify-image:
    image: bitnami/cosign:latest
    command: >
      verify
        --certificate-oidc-issuer "https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c"
        --certificate-identity-regexp "https://circleci\\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*"
        fabiocicerchia/nginx-lua:latest
    restart: "no"
```

#### Integrate verification into Kubernetes

Using [Sigstore Policy Controller](https://docs.sigstore.dev/policy-controller/overview/):

```yaml
# ClusterImagePolicy resource
apiVersion: policy.sigstore.dev/v1beta1
kind: ClusterImagePolicy
metadata:
  name: nginx-lua-verify
spec:
  images:
    - glob: "docker.io/fabiocicerchia/nginx-lua:*"
  authorities:
    - keyless:
        url: https://fulcio.sigstore.dev
        identities:
          - issuer: "https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c"
            subjectRegExp: "https://circleci\\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*"
      ctlog:
        url: https://rekor.sigstore.dev
```

This rejects any pod using an unverified `fabiocicerchia/nginx-lua` image.

## Software Bill of Materials (SBOM)

Every published image includes **per-platform** signed SBOM attestations in
**CycloneDX** format, generated by [Syft](https://github.com/anchore/syft).
SBOMs are generated separately for `linux/amd64` and `linux/arm64` (since
platform-specific packages differ) and attached to **both** the index image
digest and the per-arch image digest.

This means:
- **Pull by tag**: SBOM is available on the index — filter by platform using
  the CycloneDX `metadata.component.name` field
- **Pull by digest**: SBOM is directly attached to the per-arch image with the
  correct platform-specific content

### Retrieving the SBOM

```bash
# Verify and retrieve all CycloneDX SBOM attestations for an image
cosign verify-attestation \
    --type cyclonedx \
    --certificate-oidc-issuer "https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c" \
    --certificate-identity-regexp "https://circleci\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*" \
    fabiocicerchia/nginx-lua:latest | jq -r '.payload' | base64 -d | jq .

# Retrieve the SBOM for a specific platform (e.g. linux/amd64)
cosign verify-attestation \
    --type cyclonedx \
    --certificate-oidc-issuer "https://oidc.circleci.com/org/139dac99-01a5-4da1-9a56-a8699c0a2c7c" \
    --certificate-identity-regexp "https://circleci\.com/api/v2/projects/1d8730b7-9e11-4e2e-a1e3-3e21afa59503/pipeline-definitions/.*" \
    fabiocicerchia/nginx-lua:latest | jq -r '.payload' | base64 -d | \
    jq 'select(.predicate.metadata.component.name | contains("linux/amd64"))'
```

### CRA Article 47 Compliance

The SBOM includes:
- All OS-level packages installed in the image
- All compiled-from-source components and their versions
- All Lua libraries and their versions
- Dependency relationships and license information

## Vulnerability Scanning

All images are scanned with [Trivy](https://github.com/aquasecurity/trivy)
before publication. The pipeline **blocks publication** of images containing
CRITICAL severity vulnerabilities with known fixes.

Scanning covers:
- OS package vulnerabilities (CVE database)
- Application dependency vulnerabilities
- Dockerfile misconfigurations
- Embedded secrets detection

## Source Integrity

### Dependency Downloads
- All source dependencies are downloaded over HTTPS with TLS verification
- Downloads use `curl -sf` (fail on HTTP errors, silent)
- SHA256 checksums are logged for audit trail
- The nginx source tarball PGP signature is downloaded when available

### Build Reproducibility
- All dependency versions are pinned explicitly (no `latest` tags)
- Build arguments include VCS_REF and BUILD_DATE for traceability
- Docker layer caching is disabled in CI to prevent cache poisoning attacks

## Code Review

- All changes require review via GitHub CODEOWNERS
- CI/CD pipeline files, Dockerfiles, and build scripts require maintainer review
- Security-sensitive files (SECURITY.md, CODEOWNERS) require maintainer review

## Vulnerability Disclosure

See [SECURITY.md](SECURITY.md) for our vulnerability disclosure policy.
Machine-readable security contact: [.github/security.txt](.github/security.txt) (RFC 9116).

## Regulatory Compliance

| Requirement | Status | Implementation |
|---|---|---|
| CRA Art. 47 - SBOM | Implemented | Signed per-platform CycloneDX SBOM per index image |
| CRA Art. 11 - Vulnerability handling | Implemented | Trivy scanning gate, SECURITY.md |
| CRA Art. 13 - Security contact | Implemented | security.txt (RFC 9116) |
| NIS2 Art. 21(2)(d) - Supply chain security | Implemented | Signed images, CODEOWNERS, verified downloads |
| NIS2 Art. 21(2)(e) - Vulnerability handling | Implemented | Trivy scanning, disclosure policy |
| GDPR Art. 25 - Data protection by design | Documented | See GDPR section below |

## GDPR Considerations

This Docker image includes the **GeoIP2 module** (`ngx_http_geoip2_module`)
which processes IP addresses. Under GDPR, IP addresses are considered personal
data (Recital 30).

### For users of this image:
- **You** are the data controller when you deploy this image
- If you enable GeoIP lookups, you must:
  - Document IP address processing in your Records of Processing Activities (ROPA)
  - Ensure a lawful basis for processing (Art. 6)
  - Include IP geolocation in your privacy notice (Art. 13/14)
  - Consider Data Protection Impact Assessment if processing at scale (Art. 35)
- The GeoIP module is **optional** - it is included but not active by default
- MaxMind GeoLite2 databases are NOT bundled in the image (user must provide them)
- Access logs (IP addresses) are forwarded to stdout/stderr by default

### For the build pipeline:
- MaxMind GeoLite2 databases are downloaded during CI **testing only**
- Test GeoIP data is not included in published images
- CI credentials (MAXMIND_ACCOUNT_ID) are stored as CircleCI secrets
