@domain:quality @area:test-base @from:bin/package-test-base
Feature: Checking that built packages install and run
  Lets a release operator confirm a built nginx package installs on a target distribution and ships the expected runtime tools before it is released.

  Background:
    Given Packages built for the distribution are in the dist directory

  @id:bin.quality.test-base.001 @rule:quality.package-test.installs-and-ships-runtime-tools @inferred @source:bin/package-test-base.sh#main
  Scenario: A built package must install and provide nginx, Lua tooling and envsubst
    Given a built nginx package for debian and nginx version 1.27.0 exists in dist
    When the release operator runs the package test for debian, nginx 1.27.0 and amd64
    Then the package matching 1.27.0 is installed in a clean debian container
    And the test fails if envsubst, nginx -V, nginx -t, luajit -v, lua -v or luarocks --version fails
    And the standard image test suite then runs against the installed package
    And the test container is removed when the run ends

  @id:bin.quality.test-base.002 @rule:quality.package-test.package-format-per-distro @inferred @source:bin/package-test-base.sh#main @questionable
  Scenario Outline: Each distribution is tested with its own package format
    Given built packages exist for every supported distribution
    When the release operator runs the package test for <distro>
    Then the <format> package matching the nginx version is installed with <installer>

    Examples:
      | distro      | format | installer                 |
      | alpine      | apk    | apk add --allow-untrusted |
      | almalinux   | rpm    | yum install               |
      | amazonlinux | rpm    | yum install               |
      | fedora      | rpm    | yum install               |
      | debian      | deb    | apt install               |
      | ubuntu      | deb    | apt install               |

  @id:bin.quality.test-base.003 @rule:quality.package-test.requires-three-arguments @inferred @source:bin/package-test-base.sh#parse_arguments
  Scenario Outline: The package test refuses to run without distribution, version and architecture
    Given no other state is required
    When the release operator runs the package test with only <args>
    Then it prints "Error: Expected 3 arguments, got <count>"
    And it points the operator to --help
    And it exits with status 1 without starting any container

    Examples:
      | args                      | count |
      | debian                    | 1     |
      | debian 1.27.0             | 2     |
      | debian 1.27.0 amd64 extra | 4     |

  @id:bin.quality.test-base.004 @rule:quality.package-test.help-available @inferred @source:bin/package-test-base.sh#show_help
  Scenario: The operator can read usage help
    Given no other state is required
    When the release operator runs the package test with --help
    Then it lists the arguments: distro (alpine, almalinux, amazonlinux, debian, fedora, ubuntu), nginx_version and arch (amd64, arm64)
    And it exits with status 0 without starting any container
