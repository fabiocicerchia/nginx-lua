@domain:image-catalog @area:image-definitions @from:bin/common
Feature: Generating per-distro Dockerfiles
  Gives maintainers and auditors a committed Dockerfile for every supported nginx version and distro, built from shared templates.

  Background:
    Given the supported nginx mainline version is 1.31.8 and the supported stable version is 1.30.6

  @id:bin.image-catalog.image-definitions.001 @rule:images.definitions.one-per-version-and-distro @inferred @source:bin/common.py#setup_dockerfile
  Scenario Outline: Each supported distro gets a Dockerfile for both mainline and stable
    Given <distro> <os_version> is a supported distro
    When the maintainer generates the Dockerfiles
    Then nginx/1.31.8/<distro>/<os_version>/Dockerfile exists
    And nginx/1.30.6/<distro>/<os_version>/Dockerfile exists

    Examples:
      | distro      | os_version         |
      | almalinux   | 10.2-20261027      |
      | alpine      | 3.24.3             |
      | amazonlinux | 2023.12.20261102.0 |
      | debian      | 13.7               |
      | fedora      | 45                 |
      | ubuntu      | 26.04              |

  @id:bin.image-catalog.image-definitions.002 @rule:images.definitions.placeholders-filled @inferred @source:bin/common.py#patch_dockerfile @questionable
  Scenario: Generated Dockerfiles have the image, distro and version placeholders filled in
    Given the debian template references {{DOCKER_IMAGE}}, {{DOCKER_IMAGE_OS}}, {{DOCKER_IMAGE_TAG}}, {{VER_NGINX}} and {{VER_LUAJIT}}
    And the pinned dependency list sets VER_LUAJIT=v2.1-20261001 and contains a commented-out line
    When the maintainer generates the Dockerfiles
    Then nginx/1.31.8/debian/13.7/Dockerfile names fabiocicerchia/nginx-lua, debian, 13.7, 1.31.8 and v2.1-20261001 where the placeholders were
    And the commented-out line in the dependency list sets no value
