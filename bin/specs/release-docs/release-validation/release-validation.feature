@domain:release-docs @area:release-validation @from:bin/validate-release
Feature: Validating a GitHub release before it ships
  Lets the maintainer confirm a tagged release has every Dockerfile, package and checksum it should, and that they match the tagged commit.

  Background:
    Given the maintainer validates releases of the nginx-lua repository

  @id:bin.release-docs.release-validation.001 @rule:release.validation.tag-required @inferred @source:bin/validate-release.sh#usage
  Scenario Outline: A release check needs an existing release tag
    Given no release tag <tag> exists in the repository
    When the maintainer runs the release validation with tag argument <tag>
    Then the output says "<output>"
    And the command exits with status 1

    Examples:
      | tag                | output                                                |
      | (none)             | Usage: validate-release.sh <release-tag>              |
      | v9.99999999.999999 | ERROR: Tag v9.99999999.999999 not found in repository |

  @id:bin.release-docs.release-validation.002 @rule:release.validation.checksum-manifest-required @inferred @source:bin/validate-release.sh#download_asset
  Scenario: A release without a checksum list cannot be validated
    Given the release has no SHA256SUMS file
    When the maintainer runs the release validation
    Then the output shows "FAIL: SHA256SUMS not found in release"
    And the output says "Cannot continue without SHA256SUMS"
    And the command exits with status 1
