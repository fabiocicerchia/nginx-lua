@domain:publishing @area:tagging @from:bin/common
Feature: Image tag scheme
  Tells users which tags each nginx-lua image is published under, so they can pin a patch version or follow mainline.

  Background:
    Given the supported versions list names nginx 1.31.0 as mainline and 1.30.1 as stable

  @id:bin.publishing.tagging.001 @rule:publishing.tagging.broad-tags-mainline-only @inferred @source:bin/common.py#generate_tags
  Scenario Outline: Broad tags are given only to the mainline build
    Given nginx <nginx_version> is the <line> version
    When the release pipeline computes the tags for a debian image of nginx <nginx_version>
    Then the image gets the "debian" tag: <has_debian>
    And the image gets the "1-debian" tag: <has_1-debian>
    And the image gets a minor-qualified debian tag: <has_minor-debian>

    Examples:
      | nginx_version | line     | has_debian | has_1-debian | has_minor-debian  |
      | 1.31.0        | mainline | yes        | yes          | yes (1.31-debian) |
      | 1.30.1        | stable   | no         | no           | yes (1.30-debian) |

  @id:bin.publishing.tagging.002 @rule:publishing.tagging.default-distro-short-tags @inferred @source:bin/common.py#generate_tags
  Scenario Outline: The default distribution is published under short tags, including latest for mainline
    Given alpine is the default distribution
    When the release pipeline computes the tags for a <distro> image of nginx <nginx_version>
    Then the tags without a distribution suffix are: <tags_without_distro_suffix>

    Examples:
      | distro | nginx_version | tags_without_distro_suffix |
      | alpine | 1.31.0        | latest, 1, 1.31, 1.31.0    |
      | alpine | 1.30.1        | 1.30, 1.30.1               |
      | ubuntu | 1.31.0        | none                       |

  @id:bin.publishing.tagging.003 @rule:publishing.tagging.architecture-suffix @inferred @source:bin/common.py#generate_tags
  Scenario Outline: Per-architecture tags carry an architecture suffix
    Given nginx 1.31.0 is the mainline version
    When the release pipeline computes the tags for a debian image for architecture "<arch>"
    Then the tags include "<tag>"
    And every tag ends with the architecture suffix when an architecture is given

    Examples:
      | arch  | tag                                          |
      |       | fabiocicerchia/nginx-lua:1.31.0-debian       |
      | arm64 | fabiocicerchia/nginx-lua:1.31.0-debian-arm64 |
