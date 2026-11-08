@domain:publishing @area:tagging @from:bin/common
Feature: Image tag scheme
  Tells users which tags each nginx-lua image is published under, so they can pin a patch version or follow mainline.

  Background:
    Given Given the supported versions list names a mainline and a stable nginx version

  @id:bin.publishing.tagging.001 @rule:publishing.tagging.broad-tags-mainline-only @inferred @source:bin/common.py#generate_tags
  Scenario Outline: Broad tags are given only to the mainline build
    Given nginx 1.31.0 is the mainline version and 1.30.1 is the stable version
    When the release pipeline computes the tags for a debian image
    Then the mainline image gets the tags "debian" and "1-debian"
    And the stable image gets neither "debian" nor "1-debian"
    And both images get minor-qualified tags such as "<minor>-debian"

    Examples:
      | nginx_version | line     | has_debian | has_1-debian | has_minor-debian  |
      | 1.31.0        | mainline | yes        | yes          | yes (1.31-debian) |
      | 1.30.1        | stable   | no         | no           | yes (1.30-debian) |

  @id:bin.publishing.tagging.002 @rule:publishing.tagging.default-distro-short-tags @inferred @source:bin/common.py#generate_tags
  Scenario Outline: The default distribution is published under short tags, including latest for mainline
    Given alpine is the default distribution
    And nginx 1.31.0 is the mainline version and 1.30.1 is the stable version
    When the release pipeline computes the tags for an alpine image
    Then the mainline image gets "latest", "1", "1.31" and "1.31.0"
    And the stable image gets "1.30" and "1.30.1" but not "latest" or "1"
    And a non-default distribution such as ubuntu gets no bare version tags and no "latest"

    Examples:
      | distro | nginx_version | tags_without_distro_suffix |
      | alpine | 1.31.0        | latest, 1, 1.31, 1.31.0    |
      | alpine | 1.30.1        | 1.30, 1.30.1               |
      | ubuntu | 1.31.0        | none                       |

  @id:bin.publishing.tagging.003 @rule:publishing.tagging.architecture-suffix @inferred @source:bin/common.py#generate_tags
  Scenario Outline: Per-architecture tags carry an architecture suffix
    Given nginx 1.31.0 is the mainline version
    When the release pipeline computes the tags for a debian image on arm64
    Then every tag ends with "-arm64", for example "fabiocicerchia/nginx-lua:1.31.0-debian-arm64"
    And tags are listed shortest first, then alphabetically

    Examples:
      | arch  | tag                                          |
      |       | fabiocicerchia/nginx-lua:1.31.0-debian       |
      | arm64 | fabiocicerchia/nginx-lua:1.31.0-debian-arm64 |
