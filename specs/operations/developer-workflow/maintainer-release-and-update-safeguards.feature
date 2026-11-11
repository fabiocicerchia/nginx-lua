@domain:operations @area:developer-workflow @from:nginx-lua/makefile
Feature: Safe updates and releases
  Lets the maintainer refresh upstream entrypoints and publish releases while refusing tampered or unreleased inputs and duplicate releases.

  Background:
    Given The maintainer runs make targets from the repository root

  @id:operations.developer-workflow.001 @rule:build.entrypoints.refuse-tampered-files @inferred @source:Makefile#pull-nginx-entrypoints
  Scenario: Tampered entrypoint files block the update
    Given the entrypoint files differ from the recorded checksums
    When the maintainer runs make pull-nginx-entrypoints
    Then the output shows "ERROR: Entrypoint files have been tampered with since last update"
    And the command exits with a failure
    And no upstream entrypoint file is downloaded

  @id:operations.developer-workflow.002 @rule:build.entrypoints.require-tagged-upstream @inferred @source:Makefile#pull-nginx-entrypoints
  Scenario: Entrypoints are only taken from a tagged upstream release
    Given the latest upstream nginx tag has no release page
    When the maintainer runs make pull-nginx-entrypoints
    Then the output shows "Refusing to fall back to master."
    And the command exits with a failure
    And the local entrypoint files are unchanged

  @id:operations.developer-workflow.003 @rule:build.release.one-release-per-nginx-version @inferred @source:Makefile#release
  Scenario: An already released nginx version is not released again
    Given the tag v1.30.3 already exists on the remote
    When the maintainer runs make release
    Then the output shows "=== v1.30.3 already released, skipping ==="
    And no release is created for v1.30.3
    And other supported nginx versions without a tag are still released

  @id:operations.developer-workflow.004 @rule:build.release.verified-release-tool @inferred @source:Makefile#release
  Scenario: Release tooling download is checksum-verified
    Given the downloaded release tool does not match its pinned SHA-256
    When the maintainer runs make release
    Then the download step fails
    And no release is published
