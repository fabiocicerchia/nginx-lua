@domain:publishing @area:package-testing @from:bin/package-test-base
Feature: Testing native nginx packages on a clean base system
  Lets the release operator confirm that the built deb, rpm and apk packages for an nginx version install on a fresh distro image and give a working nginx and Lua toolchain before they are published.

  Background:
    Given the built packages for the release are in the dist directory of the working copy

  @id:bin.publishing.package-testing.001 @rule:packages.install-test.installs-on-clean-distro @inferred @source:bin/package-test-base.sh#main
  Scenario Outline: The package for a version installs on a fresh image of its distro and the bundled tools respond
    Given packages for nginx <nginx_version> exist in the dist directory as <package_type> files
    When the operator runs the package install test for <distro>, nginx <nginx_version> and amd64
    Then a fresh <distro>:latest container named test-<package_type> is started with the dist directory available as /app
    And only the <package_type> packages whose names contain <nginx_version> are installed with <installer>
    And envsubst, nginx -V, the nginx configuration test, luajit, lua and luarocks each report their version or configuration
    And the image test suite then runs for <distro> and amd64

    Examples:
      | distro      | nginx_version | package_type | installer                    |
      | alpine      | 1.27.3        | apk          | apk add --allow-untrusted    |
      | almalinux   | 1.27.3        | rpm          | yum install                  |
      | amazonlinux | 1.27.3        | rpm          | yum install                  |
      | fedora      | 1.27.3        | rpm          | yum install                  |
      | debian      | 1.27.3        | deb          | apt install after apt update |
      | ubuntu      | 1.27.3        | deb          | apt install after apt update |

  @id:bin.publishing.package-testing.002 @rule:packages.install-test.any-failed-check-fails-run @inferred @source:bin/package-test-base.sh#main
  Scenario: A package that fails to install or breaks a bundled tool fails the test
    Given the package for nginx 1.27.3 on debian installs but its nginx configuration test fails
    When the operator runs the package install test for debian, nginx 1.27.3 and amd64
    Then the run stops at the failing check with a non-zero exit status
    And the image test suite is not run
    And the test-deb container is removed

  @id:bin.publishing.package-testing.003 @rule:packages.install-test.requires-distro-version-arch @inferred @source:bin/package-test-base.sh#parse_arguments
  Scenario Outline: The test refuses to run without exactly a distro, an nginx version and an architecture
    When the operator runs the package install test with <arguments>
    Then the error "<message>" is shown with a pointer to --help
    And the run exits with status 1 and no container is started

    Examples:
      | arguments                 | message                            |
      | debian 1.27.3             | Error: Expected 3 arguments, got 2 |
      | debian 1.27.3 amd64 extra | Error: Expected 3 arguments, got 4 |
      | "" 1.27.3 amd64           | Error: Missing required arguments  |

  @id:bin.publishing.package-testing.004 @rule:packages.install-test.unsupported-distro-not-refused @inferred @source:bin/package-test-base.sh#main @questionable
  Scenario: An unsupported distro is not refused up front
    When the operator runs the package install test for centos, nginx 1.27.3 and amd64
    Then no unsupported-distro error is shown
    And a centos:latest container named test- is started and no package is installed
    And the run fails only when the first toolchain check cannot find envsubst or nginx

  @id:bin.publishing.package-testing.005 @rule:packages.install-test.arch-not-applied-to-install @inferred @source:bin/package-test-base.sh#main @questionable
  Scenario: The chosen architecture does not select the platform the packages are installed on
    Given the operator's machine is amd64
    When the operator runs the package install test for ubuntu, nginx 1.27.3 and arm64
    Then the ubuntu:latest container runs on the machine's own amd64 platform
    And every .deb in dist whose name contains 1.27.3 is offered to the installer, whatever its architecture
    And arm64 is passed only to the image test suite
