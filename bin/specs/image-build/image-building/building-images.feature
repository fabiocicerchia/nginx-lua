@domain:image-build @area:image-building @from:bin/docker-build
Feature: Building images for an OS and architecture
  Lets a release operator build both the mainline and stable nginx images for one OS distribution and CPU architecture and stops at the first failing build.

  @id:bin.image-build.image-building.001 @rule:image-build.image-building.mainline-and-stable-per-os-arch @inferred @source:bin/docker-build.py#main
  Scenario: Both mainline and stable images are built for the chosen OS and architecture
    Given the supported versions list names a mainline and a stable nginx version and a version for alpine
    When the operator builds images for alpine on amd64
    Then the mainline nginx image is built first, then the stable nginx image
    And both images are built for the amd64 architecture
    And the list of local images is printed at the end

  @id:bin.image-build.image-building.002 @rule:image-build.image-building.arm64-alias @inferred @source:bin/docker-build.py#main
  Scenario: The arm64 architecture builds arm64v8 images
    Given the supported versions list names a mainline and a stable nginx version and a version for debian
    When the operator builds images for debian on arm64
    Then the images are built for the arm64v8 architecture

  @id:bin.image-build.image-building.003 @rule:image-build.image-building.stop-on-first-failure @inferred @source:bin/common.py#for_mainline_and_stable
  Scenario: A failed build stops the run with a failure status
    Given the mainline image build fails
    When the operator builds images for ubuntu on amd64
    Then the build exits with status 1
    And the stable image is not built
    And the list of local images is not printed
