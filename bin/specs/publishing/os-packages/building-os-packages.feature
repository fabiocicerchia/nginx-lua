@domain:publishing @area:os-packages @from:bin/package-base-nginx
Feature: Building native nginx packages
  Lets the release operator produce an installable nginx-lua package (apk, rpm or deb) for one distribution, nginx version and architecture, ready to publish.

  Background:
    Given the nginx-lua sources and the supported versions list are available

  @id:bin.publishing.os-packages.001 @rule:packages.build.package-format-follows-distro @inferred @source:bin/package-base-nginx.sh#main
  Scenario Outline: Each distribution gets its native package format
    Given the supported versions list names an OS release for <distro>
    When the operator builds the package for <distro>, nginx 1.27.3 on amd64
    Then a <format> package for nginx-lua 1.27.3 is placed in the dist folder
    And the file list of the package is printed

    Examples:
      | distro      | format |
      | alpine      | apk    |
      | almalinux   | rpm    |
      | amazonlinux | rpm    |
      | fedora      | rpm    |
      | debian      | deb    |
      | ubuntu      | deb    |

  @id:bin.publishing.os-packages.002 @rule:packages.build.apk-name-carries-architecture @inferred @source:bin/package-base-nginx.sh#main
  Scenario Outline: Alpine packages are named after their architecture
    Given the dist folder has no packages yet
    When the operator builds the package for alpine, nginx 1.27.3 on <arch>
    Then the apk file name in the dist folder ends with "_<arch>.apk"

    Examples:
      | arch  |
      | amd64 |
      | arm64 |

  @id:bin.publishing.os-packages.003 @rule:packages.build.rebuild-replaces-same-version-only @inferred @source:bin/package-base-nginx.sh#main @questionable
  Scenario: Rebuilding a version replaces only that version's packages
    Given the dist folder already holds deb packages for nginx 1.27.3 and nginx 1.26.2
    When the operator builds the package for debian, nginx 1.27.3 on amd64
    Then the old nginx 1.27.3 deb package is replaced by the new one
    And the nginx 1.26.2 deb package is still in the dist folder

  @id:bin.publishing.os-packages.004 @rule:packages.cli.refuses-incomplete-arguments @inferred @source:bin/package-base-nginx.sh#parse_arguments
  Scenario Outline: A build request without distribution, version and architecture is refused
    When the operator runs the package build with <arguments>
    Then the error "<message>" is shown
    And the operator is pointed to --help
    And no package is built and the command exits with status 1

    Examples:
      | arguments                 | message                            |
      | alpine 1.27.3             | Error: Expected 3 arguments, got 2 |
      | alpine 1.27.3 amd64 extra | Error: Expected 3 arguments, got 4 |
      | "" 1.27.3 amd64           | Error: Missing required arguments  |

  @id:bin.publishing.os-packages.005 @rule:packages.cli.help-shows-usage @inferred @source:bin/package-base-nginx.sh#show_help
  Scenario Outline: Asking for help shows usage without building
    When the operator runs the package build with <arguments>
    Then the usage text listing the distributions alpine, almalinux, amazonlinux, debian, fedora, ubuntu and the architectures amd64, arm64 is shown
    And no package is built and the command exits with status 0

    Examples:
      | arguments                  |
      | --help                     |
      | -h                         |
      | alpine 1.27.3 amd64 --help |

  @id:bin.publishing.os-packages.006 @rule:packages.cli.unknown-distro-not-refused @inferred @source:bin/package-base-nginx.sh#main @questionable
  Scenario: An unsupported distribution is not refused up front
    When the operator builds the package for gentoo, nginx 1.27.3 on amd64
    Then no message names gentoo as unsupported
    And no package for gentoo is placed in the dist folder

  @id:bin.publishing.os-packages.007 @rule:packages.build.failure-reported-as-success @inferred @source:bin/package-base-nginx.sh#main @questionable
  Scenario: A failed package build still reports success
    Given the package image for debian, nginx 1.27.3 on amd64 cannot be built
    When the operator builds the package for debian, nginx 1.27.3 on amd64
    Then no new package is placed in the dist folder
    And the command exits with status 0
