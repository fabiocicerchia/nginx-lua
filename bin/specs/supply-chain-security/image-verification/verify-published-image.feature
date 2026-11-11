@domain:supply-chain-security @area:image-verification @from:bin/verify-image
Feature: Verifying a published image before use
  Lets a consumer of the nginx-lua image confirm, before running it, that it was signed by the project's release pipeline and carries an SBOM.

  Background:
    Given The consumer has the verification script and an image reference (tag or sha256 digest)

  @id:bin.supply-chain-security.image-verification.002 @rule:supply-chain-security.image-verification.signature-from-release-pipeline-required @inferred @source:bin/verify-image.sh#OIDC_ISSUER
  Scenario: An image signed by the project's release pipeline is accepted
    Given the cosign tool is installed
    And the image fabiocicerchia/nginx-lua:latest is signed by the project's CircleCI pipeline
    When the consumer verifies fabiocicerchia/nginx-lua:latest
    Then the output shows "PASS: Image signature verified"
    And the output ends with "=== Image fabiocicerchia/nginx-lua:latest verification complete ==="
    And the command exits with status 0

  @id:bin.supply-chain-security.image-verification.003 @rule:supply-chain-security.image-verification.unsigned-image-refused @inferred @source:bin/verify-image.sh#OIDC_ISSUER
  Scenario: An image not signed by the project's pipeline is refused
    Given the cosign tool is installed
    And the image example.com/evil/nginx-lua:latest has no valid signature from the project's pipeline
    When the consumer verifies example.com/evil/nginx-lua:latest
    Then the command exits with a non-zero status
    And the output does not show "PASS: Image signature verified"
    And the SBOM check is not run

  @id:bin.supply-chain-security.image-verification.004 @rule:supply-chain-security.image-verification.sbom-attestation-checked @inferred @source:bin/verify-image.sh#OIDC_ISSUER @questionable
  Scenario: A missing SBOM attestation is reported as a warning only
    Given the cosign tool is installed
    And the image is validly signed
    And the image has no CycloneDX SBOM attestation
    When the consumer verifies the image
    Then the output shows "WARN: No CycloneDX SBOM attestation found"
    And the output ends with the verification complete line
    And the command exits with status 0

  @id:bin.supply-chain-security.image-verification.005 @rule:supply-chain-security.image-verification.cosign-required @inferred @source:bin/verify-image.sh#OIDC_ISSUER
  Scenario: Verification is refused when cosign is not installed
    Given the cosign tool is not installed
    When the consumer verifies fabiocicerchia/nginx-lua:latest
    Then the output shows "ERROR: cosign is not installed. Install from https://github.com/sigstore/cosign"
    And the command exits with status 1

  @id:bin.supply-chain-security.image-verification.006 @rule:supply-chain-security.image-verification.image-reference-required @inferred @source:bin/verify-image.sh#IMAGE_REF
  Scenario: Running without an image reference shows usage and fails
    Given no image reference is supplied
    When the consumer runs the verification script
    Then the output starts with "Usage:" and shows tag and digest examples
    And the command exits with status 1
