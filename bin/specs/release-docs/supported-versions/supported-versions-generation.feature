@domain:release-docs @area:supported-versions @from:bin/generate-supported-versions
Feature: Publishing the supported versions list
  Lets the maintainer refresh the list of latest nginx and base OS versions that the project builds against.

  Background:
    Given The maintainer runs the generator from the repository root

  @id:bin.release-docs.supported-versions.003 @rule:release-docs.supported-versions.lists-latest-versions @inferred @source:bin/generate-supported-versions.py#main
  Scenario: The supported versions list records the latest nginx and OS versions
    Given Docker's official images publish nginx mainline 1.27.3 and stable 1.26.2
    And Docker's official images publish alpine 3.20.3, debian 12.7, ubuntu 24.04, fedora 41, almalinux 9.4-20241101 and amazonlinux 2023.6.20241028
    When the maintainer generates the supported versions
    Then the supported versions file lists eight lines in this order: nginx_mainline, nginx_stable, almalinux, alpine, amazonlinux, debian, fedora, ubuntu
    And the line nginx_mainline reads nginx_mainline=1.27.3
    And the line alpine reads alpine=3.20.3
    And the generated content is printed for the maintainer

  @id:bin.release-docs.supported-versions.004 @rule:release-docs.supported-versions.abort-without-overwrite @inferred @source:bin/generate-supported-versions.py#main
  Scenario Outline: Generation stops and keeps the old list when a version cannot be found
    Given the version of <component> cannot be determined from any source
    When the maintainer generates the supported versions
    Then the command exits with a failure status
    And the message <message> is shown
    And the existing supported versions file is left unchanged

    Examples:
      | component      | message                                  |
      | nginx mainline | Wrong version count in NGINX (mainline). |
      | nginx stable   | Wrong version count in NGINX (stable).   |
      | almalinux      | Wrong version count in ALMALINUX.        |
      | alpine         | Wrong version count in ALPINE.           |
      | amazonlinux    | Wrong version count in AMAZONLINUX.      |
      | debian         | Wrong version count in DEBIAN.           |
      | fedora         | Wrong version count in FEDORA.           |
      | ubuntu         | Wrong version count in UBUNTU.           |

  @id:bin.release-docs.supported-versions.005 @rule:release-docs.supported-versions.registry-fallback @inferred @source:bin/generate-supported-versions.py#fetch_specific
  Scenario: The registry is consulted when the official images listing is unavailable
    Given Docker's official images listing cannot be read
    And the registry holds an alpine latest image whose content matches the tag 3.20.3
    When the maintainer generates the supported versions
    Then a warning that the official images listing could not be fetched is shown
    And the supported versions file lists alpine=3.20.3
