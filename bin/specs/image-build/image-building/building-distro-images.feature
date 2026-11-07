@domain:image-build @area:image-building @from:bin/docker-build
Feature: Building nginx-lua images for one distribution and architecture
  Lets the release operator build both the nginx mainline and stable images of a chosen Linux distribution for one CPU architecture in a single command.

  Background:
    Given the supported versions list names an nginx mainline release, an nginx stable release and a version for each supported distribution

  @id:bin.image-build.image-building.001 @rule:image-build.distro-build.builds-mainline-and-stable @inferred @source:bin/docker-build.py#main
  Scenario Outline: One build command produces the mainline and the stable image of a distribution
    Given the supported versions list names nginx mainline 1.29.3, nginx stable 1.28.0 and <os_distro> <os_version>
    When the operator builds images for <os_distro> on <arch>
    Then an nginx 1.29.3 image of <os_distro> <os_version> is built for <built_arch>
    And then an nginx 1.28.0 image of <os_distro> <os_version> is built for <built_arch>
    And the operator sees the list of local Docker images once both builds finish

    Examples:
      | os_distro | os_version | arch    | built_arch |
      | alpine    | 3.22.2     | amd64   | amd64      |
      | debian    | 13.1       | arm64   | arm64v8    |
      | ubuntu    | 24.04      | arm64v8 | arm64v8    |

  @id:bin.image-build.image-building.002 @rule:image-build.distro-build.stops-on-first-failure @inferred @source:bin/common.py#for_mainline_and_stable
  Scenario: A failed mainline build stops the run before the stable image is built
    Given the nginx mainline image of debian fails to build
    When the operator builds images for debian on amd64
    Then the nginx stable image of debian is not built
    And the command exits with status 1
    And no list of local Docker images is shown

  @id:bin.image-build.image-building.003 @rule:image-build.distro-build.architecture-not-validated @inferred @source:bin/docker-build.py#main @questionable
  Scenario Outline: An architecture other than amd64 or arm64 is passed to the build unchecked
    When the operator builds images for alpine on <arch>
    Then the command does not refuse the architecture before building
    And the images are built with architecture <arch>

    Examples:
      | arch    |
      | x86_64  |
      | riscv64 |
