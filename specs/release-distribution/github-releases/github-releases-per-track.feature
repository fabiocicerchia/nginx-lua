@domain:release-distribution @area:github-releases @from:nginx-lua/makefile
Feature: Publishing GitHub releases per nginx track
  Gives image users one GitHub release per nginx track (stable and mainline), tagged with the exact nginx version, so they can download the Dockerfiles behind each image and check them against published checksums.

  Background:
    Given the supported nginx versions are stable 1.30.6 and mainline 1.31.8

  @id:release-distribution.github-releases.001 @rule:release.github.one-release-per-nginx-track @inferred @source:Makefile#release
  Scenario: Each nginx track gets its own release tagged with its exact version, with Dockerfiles and checksums
    Given no release exists yet for v1.30.6 or v1.31.8
    When the maintainer publishes the releases
    Then a release tagged "v1.30.6" and a release tagged "v1.31.8" are created
    And each release contains the generic Dockerfile and one Dockerfile per supported distro, named like "Dockerfile-nginx1.31.8-alpine3.24.3"
    And each release contains a SHA256SUMS file listing a checksum for every artifact
    And each release body is the changelog generated for that tag

  @id:release-distribution.github-releases.002 @rule:release.github.already-released-track-is-skipped @inferred @source:Makefile#release
  Scenario: A track whose version is already released is not released again
    Given a release tagged "v1.30.6" already exists
    And no release exists yet for v1.31.8
    When the maintainer publishes the releases
    Then the output shows "=== v1.30.6 already released, skipping ==="
    And the existing v1.30.6 release is left as it was
    And a release tagged "v1.31.8" is created
