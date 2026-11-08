@domain:image-build @area:base-packages @from:bin/package-base-nginx
Feature: Packaging nginx for each distribution
  Lets a release maintainer produce a native nginx-lua package (apk, rpm or deb) for a distribution, version and architecture.

  @id:bin.image-build.base-packages.001 @rule:image-build.base-packages.native-package-type-per-distro @inferred @source:bin/package-base-nginx.sh#main
  Scenario Outline: Each distribution gets its native package format
    When the maintainer builds the nginx package for <distro> version 1.27.4 on amd64
    Then the package produced in the dist directory has the format <format>

    Examples:
      | distro      | format |
      | alpine      | apk    |
      | almalinux   | rpm    |
      | amazonlinux | rpm    |
      | fedora      | rpm    |
      | debian      | deb    |
      | ubuntu      | deb    |

  @id:bin.image-build.base-packages.002 @rule:image-build.base-packages.alpine-package-name-includes-arch @inferred @source:bin/package-base-nginx.sh#main
  Scenario: Alpine packages carry the architecture in their file name
    When the maintainer builds the nginx package for alpine on arm64
    Then the file in the dist directory is named nginx-lua-<version>-r<release>_arm64.apk

  @id:bin.image-build.base-packages.003 @rule:image-build.base-packages.rebuild-replaces-same-version-only @inferred @source:bin/package-base-nginx.sh#main
  Scenario: Rebuilding replaces the previous package of the same nginx version only
    Given the dist directory holds nginx-lua packages for nginx 1.27.4 and 1.26.3
    When the maintainer rebuilds the package for nginx 1.27.4
    Then the older 1.27.4 package is replaced by the new one
    And the 1.26.3 package is still in the dist directory

  @id:bin.image-build.base-packages.004 @rule:image-build.base-packages.arguments-required @inferred @source:bin/package-base-nginx.sh#parse_arguments
  Scenario: The build is refused without distribution, version and architecture
    When the maintainer runs the package build with only the distribution
    Then it exits with status 1
    And the message "Error: Expected 3 arguments, got 1" is shown
    And the message points to the --help usage
