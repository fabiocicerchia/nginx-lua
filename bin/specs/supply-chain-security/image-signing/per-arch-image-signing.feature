@domain:supply-chain-security @area:image-signing @from:bin/sign-image
Feature: Signing per-architecture images
  Gives image consumers a verifiable keyless cosign signature and a signed SBOM on every per-architecture nginx-lua image the CI pipeline pushes, as supply-chain evidence.

  Background:
    Given the per-architecture image fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3-amd64 has been pushed to the registry
    And the CircleCI pipeline can issue an OIDC token for the "sigstore" audience

  @id:bin.supply-chain-security.image-signing.001 @rule:supply-chain.image-signing.per-arch-signed-by-digest-with-provenance @inferred @source:bin/sign-image.sh#sign-image.sh
  Scenario: A pushed per-architecture image is signed by digest with its build provenance
    Given the image was built from commit a1b2c3d
    When the release operator signs the image
    Then a keyless cosign signature is stored in the registry for the image's sha256 digest, not for its tag
    And the signature is annotated repo=fabiocicerchia/nginx-lua, vcs_ref=a1b2c3d, pipeline=circleci and type=per-arch
    And the signature is annotated with the UTC build date
    And the operator sees "=== Image signed successfully ==="

  @id:bin.supply-chain-security.image-signing.002 @rule:supply-chain.image-signing.refuse-unpushed-image @inferred @source:bin/sign-image.sh#sign-image.sh
  Scenario: An image that was never pushed to a registry is not signed
    Given the image fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3-arm64 exists only locally and has no registry digest
    When the release operator signs the image
    Then the operator sees "ERROR: No RepoDigests found for fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3-arm64"
    And the operator is told the image must be pushed to a registry before signing
    And the command exits with status 1 and creates no signature or SBOM

  @id:bin.supply-chain-security.image-signing.003 @rule:supply-chain.image-signing.signed-cyclonedx-sbom-attestation @inferred @source:bin/sign-image.sh#sign-image.sh @questionable
  Scenario: Every signed per-architecture image carries a signed CycloneDX SBOM attestation
    Given the image has just been signed
    When the release operator signs the image
    Then a CycloneDX SBOM of the image is generated with source name fabiocicerchia/nginx-lua and the commit as its version
    And the CycloneDX SBOM is attached to the image digest as a signed attestation of type cyclonedx
    And an SPDX SBOM is also written locally to /tmp/sbom-fabiocicerchia-nginx-lua-1.29.7-alpine3.23.3-amd64.spdx.json but is not attached to the image
    And the operator sees "=== Signed SBOM attestation attached ==="

  @id:bin.supply-chain-security.image-signing.004 @rule:supply-chain.image-signing.verify-signature-against-ci-identity @inferred @source:bin/sign-image.sh#sign-image.sh
  Scenario: A new signature must verify against the project's CircleCI identity before signing is reported done
    Given the image has been signed and its SBOM attested
    When the release operator signs the image
    Then the signature is checked against the issuer https://oidc.circleci.com/org/<organization id>
    And the signing certificate identity must match a pipeline definition of the CircleCI project
    And when verification passes, the operator sees "Image <digest> is signed, SBOM attached and verified."
    And when verification fails, the command exits non-zero and the success message is not shown

  @id:bin.supply-chain-security.image-signing.005 @rule:supply-chain.image-signing.refuse-without-signing-tools @inferred @source:bin/sign-image.sh#sign-image.sh
  Scenario Outline: Signing is refused when a required signing tool is missing
    Given <tool> is not installed on the signing host
    When the release operator signs the image
    Then the operator sees "<message>"
    And the command exits with status 1 and creates no signature

    Examples:
      | tool             | message                                                                  |
      | cosign           | ERROR: cosign is not installed                                           |
      | syft             | ERROR: syft is not installed                                             |
      | the circleci CLI | ERROR: circleci CLI is not installed (required for OIDC keyless signing) |

  @id:bin.supply-chain-security.image-signing.006 @rule:supply-chain.image-signing.image-reference-required @inferred @source:bin/sign-image.sh#sign-image.sh @questionable
  Scenario: Signing without an image reference is refused
    When the release operator runs the signing command without an image reference
    Then the command exits non-zero and creates no signature
    And the operator sees a shell "unbound variable" error, not the "Usage: <script> <image-reference>" message
