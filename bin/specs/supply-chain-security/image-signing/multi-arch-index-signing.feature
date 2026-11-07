@domain:supply-chain-security @area:image-signing @from:bin/sign-manifest
Feature: Signing multi-arch image indexes
  Gives image consumers who pull nginx-lua by tag a verifiable keyless signature and per-platform SBOMs on the multi-arch index the tag resolves to.

  Background:
    Given the multi-arch manifest list for the image reference has been pushed to the registry
    And the release pipeline runs in CircleCI with an OIDC identity for sigstore

  @id:bin.supply-chain-security.image-signing.007 @rule:supply-chain.image-signing.index-signed-keyless-with-provenance-annotations @inferred @source:bin/sign-manifest.sh#sign-manifest.sh
  Scenario: The multi-arch index is signed keylessly at its registry digest with provenance annotations
    Given the image reference "fabiocicerchia/nginx-lua:1.29.7-alpine3.22" resolves to a manifest list in the registry
    And the build is at source revision "374a60cd"
    When the release pipeline signs the manifest list for "fabiocicerchia/nginx-lua:1.29.7-alpine3.22"
    Then a cosign signature is attached to "fabiocicerchia/nginx-lua@sha256:<index digest>", where the digest is computed over the exact manifest bytes the registry stores
    And the signature carries the annotations repo=fabiocicerchia/nginx-lua, vcs_ref=374a60cd, pipeline=circleci, type=manifest-list and a UTC build_date
    And the signing certificate is issued from the pipeline's CircleCI OIDC identity, with no long-lived key
    And the output ends with "Signed: index fabiocicerchia/nginx-lua@sha256:<index digest>"

  @id:bin.supply-chain-security.image-signing.008 @rule:supply-chain.image-signing.index-carries-per-platform-sbom @inferred @source:bin/sign-manifest.sh#sign-manifest.sh
  Scenario: Each Linux platform in the index gets its own CycloneDX SBOM attestation on the index
    Given the manifest list covers the platforms linux/amd64 and linux/arm64
    And the SBOM generator is available
    When the release pipeline signs the manifest list for "fabiocicerchia/nginx-lua:1.29.7-alpine3.22"
    Then one CycloneDX SBOM per Linux platform is generated from the image for that platform
    And each SBOM names its source as "fabiocicerchia/nginx-lua@<platform>", with the source revision as its version
    And each SBOM is attached to the index digest as a cyclonedx attestation
    And entries in the manifest list that are not Linux get no SBOM

  @id:bin.supply-chain-security.image-signing.009 @rule:supply-chain.image-signing.sbom-skipped-without-generator @inferred @source:bin/sign-manifest.sh#sign-manifest.sh @questionable
  Scenario: Without the SBOM generator the index is still signed but carries no SBOM
    Given the SBOM generator is not installed on the signing host
    When the release pipeline signs the manifest list for "fabiocicerchia/nginx-lua:1.29.7-alpine3.22"
    Then the operator sees "WARN: syft not installed, skipping SBOM generation"
    And the index signature is still attached and verified
    And no SBOM attestation is attached to the index
    And the run ends without an error

  @id:bin.supply-chain-security.image-signing.010 @rule:supply-chain.image-signing.index-signature-verified-against-pipeline-identity @inferred @source:bin/sign-manifest.sh#sign-manifest.sh
  Scenario: A signed index must verify against the project's CircleCI identity before the run succeeds
    Given the index has just been signed
    When the release pipeline signs the manifest list for "fabiocicerchia/nginx-lua:1.29.7-alpine3.22"
    Then the index signature is checked against the issuer "https://oidc.circleci.com/org/<organisation id>"
    And the certificate identity must match "https://circleci.com/api/v2/projects/<project id>/pipeline-definitions/..."
    And the operator sees "=== Index signature verified ===" when the check passes
    And the run fails with a non-zero exit when the check fails

  @id:bin.supply-chain-security.image-signing.011 @rule:supply-chain.image-signing.refuses-when-prerequisites-missing @inferred @source:bin/sign-manifest.sh#sign-manifest.sh
  Scenario Outline: Signing is refused when a prerequisite is missing or the index cannot be read
    Given <condition>
    When the release pipeline signs the manifest list for "fabiocicerchia/nginx-lua:1.29.7-alpine3.22"
    Then the operator sees "<message>"
    And no signature or SBOM is attached to the index
    And the run exits with status 1

    Examples:
      | condition                                          | message                                                                       |
      | cosign is not installed                            | ERROR: cosign is not installed                                                |
      | jq is not installed                                | ERROR: jq is not installed                                                    |
      | the image reference does not exist in the registry | ERROR: Cannot resolve manifest for fabiocicerchia/nginx-lua:1.29.7-alpine3.22 |
      | the manifest list contains no Linux platforms      | ERROR: No linux platforms found in manifest list                              |
      | the CircleCI CLI is not installed                  | ERROR: circleci CLI is not installed (required for OIDC keyless signing)      |

  @id:bin.supply-chain-security.image-signing.012 @rule:supply-chain.image-signing.requires-image-reference @inferred @source:bin/sign-manifest.sh#sign-manifest.sh @questionable
  Scenario: Signing without an image reference is refused
    Given no image reference is given
    When the operator runs the manifest signing command
    Then through "make sign-manifest" with an empty IMAGE, the operator sees "Usage: ./bin/sign-manifest.sh <image-reference>" and an example reference
    And when the script is called directly with no argument, the operator sees a shell "unbound variable" error instead of the usage text
    And the run exits with a non-zero status and nothing is signed
