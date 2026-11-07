@domain:image-build @area:image-building @from:bin/docker-ops
Feature: Building per-architecture images
  Gives operators and image consumers images whose build metadata identifies exactly which commit and architecture they came from, and which rebuild to the same digest.

  Background:
    Given the supported versions list names an nginx mainline and an nginx stable release and a version for each distro

  @id:bin.image-build.image-building.004 @rule:image-build.metadata.build-date-from-commit @inferred @source:bin/docker_ops.py#get_build_date
  Scenario: Rebuilding the same commit stamps the same build date
    Given the repository is checked out at a commit made on 2026-11-05 at 17:42 UTC
    When the operator builds the alpine images for amd64, today or on any later day
    Then each image's build date is "2026-11-05T00:00:00Z"
    And rebuilding the same commit later gives the same build date

  @id:bin.image-build.image-building.005 @rule:image-build.metadata.commit-and-arch-recorded @inferred @source:bin/docker_ops.py#build_image
  Scenario Outline: A built image records its source commit and target architecture and carries every generated tag
    Given the repository is checked out at short commit "374a60c"
    When the operator builds the <distro> images for <arch>
    Then each image is built with VCS_REF "374a60c" and ARCH "<arch>"
    And each image is tagged with every tag generated for that nginx version, distro and architecture, such as "<example_tag>"

    Examples:
      | distro | arch    | example_tag             |
      | alpine | amd64   | 1.31.0-alpine3.22-amd64 |
      | debian | arm64v8 | 1.30.1-debian13-arm64v8 |

  @id:bin.image-build.image-building.006 @rule:image-build.build.failure-stops-run @inferred @source:bin/docker_ops.py#build_docker_image
  Scenario: A failed mainline build stops the run before the stable build
    Given the mainline image for alpine fails to build
    When the operator builds the alpine images
    Then the stable image is not built
    And the run exits with status 1
