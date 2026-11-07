@domain:image-catalog @area:supported-versions @from:bin/generate-supported-versions
Feature: Refreshing the supported nginx and distribution versions
  Lets the maintainer pin, in one supported_versions file, the exact nginx mainline/stable releases and base-distribution releases every image, tag, package and release is built from.

  Background:
    Given the upstream nginx and distribution images publish full release tags alongside moving aliases such as mainline, stable and latest

  @id:bin.image-catalog.supported-versions.001 @rule:image-catalog.supported-versions.file-lists-nginx-and-distro-releases @inferred @source:bin/generate-supported-versions.py#main
  Scenario: The supported versions file pins nginx mainline, nginx stable and six distributions in a fixed order
    Given upstream resolves every tracked image to a full release version
    When the maintainer generates the supported versions
    Then a supported_versions file is written with one key=value line per entry
    And the lines are, in order, nginx_mainline, nginx_stable, almalinux, alpine, amazonlinux, debian, fedora, ubuntu
    And the last six lines name exactly the distributions, as distro=version
    And the generated content is printed after "Generated supported versions:"

  @id:bin.image-catalog.supported-versions.002 @rule:image-catalog.supported-versions.alias-resolved-to-full-release @inferred @source:bin/generate-supported-versions.py#fetch_specific
  Scenario Outline: Each tracked image is pinned to the highest full release version behind its moving alias
    Given the <image> image's <alias> alias currently points at releases including <full_release>
    When the maintainer generates the supported versions
    Then the <key> entry is <full_release>
    And short aliases such as 1, 1.29, trixie or noble are never written as the version

    Examples:
      | image       | alias    | key            | full_release      |
      | nginx       | mainline | nginx_mainline | 1.29.3            |
      | nginx       | stable   | nginx_stable   | 1.28.0            |
      | almalinux   | latest   | almalinux      | 10.0-20251020     |
      | alpine      | latest   | alpine         | 3.22.2            |
      | amazonlinux | latest   | amazonlinux    | 2023.9.20251027.0 |
      | debian      | latest   | debian         | 13.1              |
      | fedora      | latest   | fedora         | 43                |
      | ubuntu      | latest   | ubuntu         | 24.04             |

  @id:bin.image-catalog.supported-versions.003 @rule:image-catalog.supported-versions.unresolved-version-aborts-without-writing @inferred @source:bin/generate-supported-versions.py#main @questionable
  Scenario Outline: If any tracked image cannot be resolved, the run fails and the existing supported versions are kept
    Given a supported_versions file already pins the current releases
    And upstream offers no release tag for <image> matching its release pattern
    When the maintainer generates the supported versions
    Then the run prints "<message>"
    And the run exits with status 1
    And the existing supported_versions file is unchanged

    Examples:
      | image          | message                                  |
      | nginx mainline | Wrong version count in NGINX (mainline). |
      | nginx stable   | Wrong version count in NGINX (stable).   |
      | almalinux      | Wrong version count in ALMALINUX.        |
      | alpine         | Wrong version count in ALPINE.           |
      | amazonlinux    | Wrong version count in AMAZONLINUX.      |
      | debian         | Wrong version count in DEBIAN.           |
      | fedora         | Wrong version count in FEDORA.           |
      | ubuntu         | Wrong version count in UBUNTU.           |
