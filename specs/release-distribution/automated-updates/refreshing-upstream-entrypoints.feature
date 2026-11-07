@domain:release-distribution @area:automated-updates @from:nginx-lua/makefile
Feature: Refreshing upstream entrypoints and dependencies
  Keeps the image's entrypoint scripts and dependency versions in line with official upstream releases for maintainers, without letting a tampered or unreleased upstream file into the image.

  Background:
    Given the image ships the official nginx entrypoint scripts, with checksums recorded from the last refresh

  @id:release-distribution.automated-updates.001 @rule:updates.entrypoints.tampered-local-copy-blocks-refresh @inferred @source:Makefile#pull-nginx-entrypoints
  Scenario: The refresh stops if the shipped entrypoint scripts changed since the last refresh
    Given an entrypoint script no longer matches the checksum recorded at the last refresh
    When the maintainer refreshes the entrypoints from upstream
    Then the output shows "ERROR: Entrypoint files have been tampered with since last update"
    And the refresh stops with a failure
    And no entrypoint script is replaced

  @id:release-distribution.automated-updates.002 @rule:updates.entrypoints.only-from-tagged-upstream-release @inferred @source:Makefile#pull-nginx-entrypoints
  Scenario: Entrypoints are only taken from a tagged upstream release, never from its main branch
    Given the newest upstream docker-nginx tag is "1.31.8"
    And the release page for upstream tag "1.31.8" does not answer with HTTP 200
    When the maintainer refreshes the entrypoints from upstream
    Then the output shows "ERROR: Upstream tag 1.31.8 not found (HTTP 404). Refusing to fall back to master."
    And the refresh stops with a failure
    And no entrypoint script is replaced

  @id:release-distribution.automated-updates.003 @rule:updates.entrypoints.refresh-records-new-checksums @inferred @source:Makefile#pull-nginx-entrypoints
  Scenario: A refresh installs the tagged upstream entrypoints with the local patch and records their checksums
    Given the shipped entrypoint scripts match their recorded checksums
    And upstream tag "1.31.8" is published
    When the maintainer refreshes the entrypoints from upstream
    Then the five entrypoint scripts are replaced with the versions from upstream tag "1.31.8"
    And the project's patch is applied to docker-entrypoint.sh
    And new checksums of the patched scripts are recorded for the next refresh

  @id:release-distribution.automated-updates.004 @rule:updates.auto-update.opens-pull-request-only-when-changed @inferred @source:Makefile#auto-update-and-commit @questionable
  Scenario Outline: Automated updates open a pull request only when something changed
    Given the automated update is run by CI with a GitHub token
    When the CI pipeline runs the automated update with <state>
    Then <outcome>

    Examples:
      | state                                             | outcome                                                                                                                            |
      | new versions, Dockerfiles, tags or README changes | a pull request titled "Automated dependency updates" is opened against main from a branch named like "auto-update/20261107-111830" |
      | no changes                                        | no pull request is opened and the run ends with a failure                                                                          |
