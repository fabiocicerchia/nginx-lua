@domain:image-build @area:dockerfile-generation @from:bin/common
Feature: Dockerfile generation
  Produces ready-to-build Dockerfiles with versions filled in for each nginx, OS and version combination.

  @id:bin.image-build.dockerfile-generation.001 @rule:image-build.dockerfile.placeholders-filled @inferred @source:bin/common.py#patch_dockerfile
  Scenario: A generated Dockerfile has its version placeholders replaced
    Given the alpine template contains {{VER_NGINX}}, {{DOCKER_IMAGE_OS}}, {{DOCKER_IMAGE_TAG}} and a pinned-component placeholder defined in the shared version file
    When the maintainer generates the Dockerfile for nginx 1.31.0 on alpine 3.22
    Then {{VER_NGINX}} becomes 1.31.0
    And {{DOCKER_IMAGE_OS}} becomes alpine and {{DOCKER_IMAGE_TAG}} becomes 3.22
    And the pinned-component placeholder takes the value from the shared version file

  @id:bin.image-build.dockerfile-generation.002 @rule:image-build.dockerfile.build-context-bundled @inferred @source:bin/common.py#setup_dockerfile
  Scenario: Each generated image folder ships its scripts, patches, licenses and configuration
    Given the source folder has shell scripts, patches, license files, default.conf, Makefile and nginx.conf
    When the maintainer generates the Dockerfile for an image
    Then the image folder's template directory contains the shell scripts, patches, licenses and the three config files
    And the shell scripts are executable by owner and group only (mode 750)
