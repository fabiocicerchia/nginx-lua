@domain:supply-chain-security @area:image-signing @from:bin/sign-image
Feature: Signing per-architecture images
  Lets the release operator publish per-arch images that are signed keylessly and carry a signed SBOM, so consumers can verify provenance.

  Background:
    Given The operator runs the signing command from the CI pipeline right after pushing the image

  @id:bin.supply-chain-security.image-signing.001 @rule:supply-chain-security.image-signing.pushed-image-is-signed-with-sbom @inferred @source:bin/sign-image.sh#sign-image
  Scenario: A pushed image is signed and gets a signed SBOM attestation
    Given the image fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3-amd64 has been pushed to a registry
    And cosign, syft and the CircleCI CLI are installed
    When the operator signs the image
    Then the image is signed by its registry digest with annotations repo, build_date, vcs_ref, pipeline=circleci and type=per-arch
    And a CycloneDX SBOM attestation is attached to the image
    And the signature is verified against the CircleCI organisation issuer and project identity
    And the output ends with "is signed, SBOM attached and verified."

  @id:bin.supply-chain-security.image-signing.002 @rule:supply-chain-security.image-signing.refuses-unpushed-image @inferred @source:bin/sign-image.sh#sign-image
  Scenario: An image that was not pushed to a registry is refused
    Given the image exists only locally and has no registry digest
    When the operator signs the image
    Then the command exits with status 1
    And the output says "ERROR: No RepoDigests found" and that the image must be pushed before signing

  @id:bin.supply-chain-security.image-signing.003 @rule:supply-chain-security.image-signing.requires-signing-tools @inferred @source:bin/sign-image.sh#sign-image
  Scenario Outline: Signing is refused when a required tool is missing
    Given a required tool is not installed
    When the operator signs the image
    Then the command exits with status 1
    And the output names the missing tool: <message>

    Examples:
      | missing_tool | message                                                                  |
      | cosign       | ERROR: cosign is not installed                                           |
      | syft         | ERROR: syft is not installed                                             |
      | circleci     | ERROR: circleci CLI is not installed (required for OIDC keyless signing) |

  @id:bin.supply-chain-security.image-signing.004 @rule:supply-chain-security.image-signing.usage-requires-image-reference @inferred @source:bin/sign-image.sh#sign-image @questionable
  Scenario: Running without an image reference does not show usage
    Given no image reference is given
    When the operator runs the signing command
    Then the command exits with a non-zero status without signing anything
