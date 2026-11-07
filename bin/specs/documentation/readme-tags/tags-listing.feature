@domain:documentation @area:readme-tags @from:bin/generate-tags
Feature: Listing the available image tags
  Gives users of the nginx-lua images a single page (docs/TAGS.md) showing which tags exist, which Dockerfile each one is built from, and whether that image is still supported.

  Background:
    Given the repository holds one Dockerfile per nginx version, distribution and distribution version
    And the supported versions file names the nginx mainline and stable releases and one version per supported distribution

  @id:bin.documentation.readme-tags.002 @rule:docs.tags.supported-and-unsupported-sections @inferred @source:bin/generate_tags.py#main
  Scenario: The tag listing separates supported images from unsupported ones
    Given nginx mainline is 1.31.8 and nginx stable is 1.30.6
    And the supported debian version is 13.7
    And an older Dockerfile exists for nginx 1.31.7 on debian 13.7
    When the operator generates the tag listing
    Then the listing has a "Supported Tags" section and then an "Unsupported Tags" section
    And "Supported Tags" holds one entry per supported distribution, in the order almalinux, alpine, amazonlinux, debian, fedora, ubuntu, with the mainline image before the stable one
    And the nginx 1.31.7 debian 13.7 image appears only under "Unsupported Tags", and that section lists images in reverse path order
    And every entry links to its Dockerfile at https://github.com/fabiocicerchia/nginx-lua/blob/main/<path>

  @id:bin.documentation.readme-tags.003 @rule:docs.tags.alias-set-per-image @inferred @source:bin/generate_tags.py#tag_names @questionable
  Scenario Outline: Each listed image shows the tag aliases it answers to
    Given the Dockerfile <dockerfile> exists
    And no Dockerfile later in path order claims any of the same tags
    When the operator generates the tag listing
    Then the entry for <dockerfile> lists exactly the tags <tags>

    Examples:
      | dockerfile                                               | tags                                                                                                       |
      | nginx/1.31.8/alpine/3.24.3/Dockerfile                    | 1.31.8-alpine3.24.3, 1.31.8-alpine, 1.31.8-, 1.31, 1-alpine3.24.3, alpine, 1-alpine, 1, latest             |
      | nginx/1.31.8/debian/13.7/Dockerfile                      | 1.31.8-debian13.7, 1.31.8-debian, 1-debian13.7, debian, 1-debian                                           |
      | nginx/1.19.0/amazonlinux/2018.03.0.20200318.1/Dockerfile | 1.19.0-amazonlinux2018.03.0.20200318.1, 1.19.0-amazonlinux, 1-amazonlinux2018.03.0.20200318.1, amazonlinux |
      | nginx/1.21.4/debian/11.1/Dockerfile-compat               | 1.21.4-debian11.1-compat, 1.21.4-debian-compat, 1-debian11.1-compat, debian-compat, 1-debian-compat        |

  @id:bin.documentation.readme-tags.004 @rule:docs.tags.shared-alias-owned-by-last-path @inferred @source:bin/generate_tags.py#main @questionable
  Scenario: A tag shared by several images is listed only under the last one in path order
    Given Dockerfiles exist for nginx 1.31.8 on fedora 44 and on fedora 45
    And both claim the tags "fedora", "1-fedora" and "1.31.8-fedora"
    When the operator generates the tag listing
    Then "fedora", "1-fedora" and "1.31.8-fedora" appear only on the fedora 45 entry
    And the fedora 44 entry lists only "1-fedora44" and "1.31.8-fedora44"

  @id:bin.documentation.readme-tags.005 @rule:docs.tags.missing-supported-dockerfile-aborts @inferred @source:bin/generate_tags.py#main @questionable
  Scenario: Generating the listing fails when a supported image has no Dockerfile
    Given the supported versions file names debian 13.8
    And no Dockerfile exists for nginx 1.31.8 on debian 13.8
    When the operator generates the tag listing
    Then the run stops with an error and no "Unsupported Tags" section is printed
    And docs/TAGS.md is left holding only the heading and the supported entries printed before the missing one
