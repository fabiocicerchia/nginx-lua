@domain:supply-chain-security @area:image-signing @from:bin/sign-manifest
Feature: Signing multi-arch manifests
  Lets release operators publish a multi-arch nginx-lua tag whose index is signed and carries per-platform SBOMs, so consumers pulling by tag can trust and inspect it.

  Background:
    Given The operator runs bin/sign-manifest.sh in the CI bundle job after the multi-arch index has been pushed to the registry

  @id:bin.supply-chain-security.image-signing.005 @rule:supply-chain-security.image-signing.manifest-list-signed-keyless @inferred @source:bin/sign-manifest.sh#sign-manifest
  Scenario: A published multi-arch index is signed with the CI identity and build annotations
    Given the multi-arch image fabiocicerchia/nginx-lua:1.29.7-alpine is published and covers linux/amd64 and linux/arm64
    And cosign, jq and the circleci CLI are installed
    When the operator signs the manifest for fabiocicerchia/nginx-lua:1.29.7-alpine
    Then the index digest is computed from the exact manifest bytes stored in the registry
    And the index is signed keylessly with a CircleCI identity token
    And the signature is annotated with repo=fabiocicerchia/nginx-lua, vcs_ref, build_date, pipeline=circleci and type=manifest-list

  @id:bin.supply-chain-security.image-signing.006 @rule:supply-chain-security.image-signing.index-sbom-per-platform @inferred @source:bin/sign-manifest.sh#sign-manifest
  Scenario: Each linux platform's SBOM is attached to the signed index
    Given the multi-arch image fabiocicerchia/nginx-lua:1.29.7-alpine covers linux/amd64 and linux/arm64
    And syft is installed
    When the operator signs the manifest for fabiocicerchia/nginx-lua:1.29.7-alpine
    Then a CycloneDX SBOM is generated for linux/amd64 and attached to the index as an attestation
    And a CycloneDX SBOM is generated for linux/arm64 and attached to the index as an attestation
    And non-linux entries in the index get no SBOM

  @id:bin.supply-chain-security.image-signing.007 @rule:supply-chain-security.image-signing.sbom-optional-when-syft-missing @inferred @source:bin/sign-manifest.sh#sign-manifest @questionable
  Scenario: Signing still completes without SBOMs when the SBOM tool is absent
    Given syft is not installed on the signing machine
    When the operator signs the manifest for fabiocicerchia/nginx-lua:1.29.7-alpine
    Then the output warns "WARN: syft not installed, skipping SBOM generation"
    And the index is still signed and its signature verified
    And no SBOM attestations are attached

  @id:bin.supply-chain-security.image-signing.008 @rule:supply-chain-security.image-signing.refuses-unresolvable-index @inferred @source:bin/sign-manifest.sh#sign-manifest
  Scenario: An image that cannot be found in the registry is not signed
    Given fabiocicerchia/nginx-lua:9.9.9-missing does not exist in the registry
    When the operator signs the manifest for fabiocicerchia/nginx-lua:9.9.9-missing
    Then the command fails with "ERROR: Cannot resolve manifest for fabiocicerchia/nginx-lua:9.9.9-missing"
    And nothing is signed and no SBOM is attached

  @id:bin.supply-chain-security.image-signing.009 @rule:supply-chain-security.image-signing.refuses-index-without-linux-platforms @inferred @source:bin/sign-manifest.sh#sign-manifest
  Scenario: An index with no linux platform is not signed
    Given the published index for fabiocicerchia/nginx-lua:windows-only lists no linux platforms
    When the operator signs the manifest for fabiocicerchia/nginx-lua:windows-only
    Then the command fails with "ERROR: No linux platforms found in manifest list"
    And nothing is signed

  @id:bin.supply-chain-security.image-signing.011 @rule:supply-chain-security.image-signing.usage-on-missing-reference @inferred @source:bin/sign-manifest.sh#sign-manifest @questionable
  Scenario: Running without an image reference shows usage
    Given no image reference is supplied
    When the operator runs the signing command with no arguments
    Then the command exits non-zero
    And the intended output is the usage line and an example reference
