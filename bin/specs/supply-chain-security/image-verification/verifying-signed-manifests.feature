@domain:supply-chain-security @area:image-verification @from:bin/sign-manifest
Feature: Verifying signed manifests
  Gives release operators confidence that the index they just signed carries a signature from the project's CI identity, failing the pipeline otherwise.

  @id:bin.supply-chain-security.image-verification.001 @rule:supply-chain-security.image-verification.index-signature-verified-after-signing @inferred @source:bin/sign-manifest.sh#sign-manifest
  Scenario: The signed index is verified against the project's CI identity before the job succeeds
    Given the index for fabiocicerchia/nginx-lua:1.29.7-alpine has just been signed
    And the CircleCI organization and project identities are configured
    When the operator signs the manifest for fabiocicerchia/nginx-lua:1.29.7-alpine
    Then the signature is checked against the CircleCI issuer for the organization and the project's pipeline-definition identity
    And the output ends with "Index signature verified" and "Signed: index <digest>"
    And if verification fails the command exits non-zero
