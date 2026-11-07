@domain:documentation @area:image-metadata-docs @from:bin/docker-metadata
Feature: Publishing image inspection metadata
  Gives image users a browsable markdown page with the full inspection metadata of each supported mainline and stable image, per distribution.

  Background:
    Given the supported versions list names nginx mainline 1.31.8, nginx stable 1.30.6 and a version for each supported distribution

  @id:bin.documentation.image-metadata-docs.001 @rule:docs.image-metadata.page-per-mainline-and-stable-image @inferred @source:bin/docker-metadata.py#main
  Scenario Outline: Each distribution gets a metadata page for its mainline and its stable image
    Given the image fabiocicerchia/nginx-lua:<tag> is available
    When the operator generates image metadata for <distro>
    Then the page docs/metadata/<tag>.md exists
    And the page is headed "# fabiocicerchia/nginx-lua:<tag>"
    And the page contains the image's inspection metadata as a JSON block

    Examples:
      | distro | tag                 |
      | alpine | 1.31.8-alpine3.24.3 |
      | alpine | 1.30.6-alpine3.24.3 |
      | debian | 1.31.8-debian13.7   |
      | debian | 1.30.6-debian13.7   |

  @id:bin.documentation.image-metadata-docs.002 @rule:docs.image-metadata.unavailable-image-skipped-silently @inferred @source:bin/docker_ops.py#generate_metadata @questionable
  Scenario: A missing image produces no page yet the run still reports success
    Given the image fabiocicerchia/nginx-lua:1.31.8-fedora45 is neither present locally nor pullable from the registry
    When the operator generates image metadata for fedora
    Then no page docs/metadata/1.31.8-fedora45.md is written
    And the stable image page is still attempted
    And the command exits with status 0

  @id:bin.documentation.image-metadata-docs.003 @rule:docs.image-metadata.unknown-distro-refused @inferred @source:bin/docker-metadata.py#main @questionable
  Scenario: Requesting metadata for an unsupported distribution fails without writing pages
    Given the supported versions list has no entry for gentoo
    When the operator generates image metadata for gentoo
    Then the command exits with a non-zero status and an error naming gentoo
    And no page is written under docs/metadata
