@domain:image-catalog @area:image-tags @from:bin/common
Feature: Assigning image tags
  Gives image consumers predictable tags for every nginx version, distro and architecture, so that floating tags like latest never point at the wrong build.

  Background:
    Given the supported nginx mainline version is 1.31.8 and the supported stable version is 1.30.6
    And alpine is the default distro

  @id:bin.image-catalog.image-tags.001 @rule:images.tags.full-set-per-build @inferred @source:bin/common.py#generate_tags
  Scenario Outline: Every build is published under its version, distro and OS-version tags in the nginx-lua repository
    Given the image is nginx <nginx_version> on <distro> <os_version>
    When the release tooling computes the tags for the image
    Then the tags are exactly <tags>
    And every tag is in the repository fabiocicerchia/nginx-lua

    Examples:
      | nginx_version | distro | os_version | tags                                                                                                                          |
      | 1.31.8        | alpine | 3.24.3     | 1, latest, 1.31, 1.31.8, alpine, 1-alpine, 1.31-alpine, 1.31.8-alpine, 1-alpine3.24.3, 1.31-alpine3.24.3, 1.31.8-alpine3.24.3 |
      | 1.30.6        | alpine | 3.24.3     | 1.30, 1.30.6, 1.30-alpine, 1.30.6-alpine, 1.30-alpine3.24.3, 1.30.6-alpine3.24.3                                              |
      | 1.31.8        | debian | 13.7       | debian, 1-debian, 1-debian13.7, 1.31-debian, 1.31.8-debian, 1.31-debian13.7, 1.31.8-debian13.7                                |
      | 1.30.6        | debian | 13.7       | 1.30-debian, 1.30.6-debian, 1.30-debian13.7, 1.30.6-debian13.7                                                                |

  @id:bin.image-catalog.image-tags.002 @rule:images.tags.floating-tags-mainline-only @inferred @source:bin/common.py#generate_tags
  Scenario Outline: Only the mainline build gets the latest, major-only and bare distro tags
    Given the image is nginx <nginx_version> on <distro> 3.24.3
    When the release tooling computes the tags for the image
    Then the tags <shared_tags> are <assigned>

    Examples:
      | nginx_version | distro | shared_tags                                 | assigned     |
      | 1.31.8        | alpine | latest, 1, alpine, 1-alpine, 1-alpine3.24.3 | included     |
      | 1.30.6        | alpine | latest, 1, alpine, 1-alpine, 1-alpine3.24.3 | not included |

  @id:bin.image-catalog.image-tags.003 @rule:images.tags.version-only-tags-default-distro @inferred @source:bin/common.py#generate_tags
  Scenario Outline: Version-only tags always point at the default alpine image
    Given the image is nginx 1.31.8 on <distro> <os_version>
    When the release tooling computes the tags for the image
    Then the tags 1.31 and 1.31.8 are <assigned>

    Examples:
      | distro | os_version | assigned     |
      | alpine | 3.24.3     | included     |
      | debian | 13.7       | not included |
      | ubuntu | 26.04      | not included |

  @id:bin.image-catalog.image-tags.004 @rule:images.tags.arch-suffix @inferred @source:bin/common.py#generate_tags
  Scenario: Per-architecture images carry the architecture as a suffix on every tag
    Given the image is nginx 1.31.8 on debian 13.7 built for amd64
    When the release tooling computes the tags for the image
    Then every tag ends in -amd64, for example fabiocicerchia/nginx-lua:1.31.8-debian13.7-amd64 and fabiocicerchia/nginx-lua:debian-amd64
    And the multi-architecture image keeps the same tags without a suffix
