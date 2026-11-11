@domain:publishing @area:tagging @from:bin/generate-tags
Feature: Image tag scheme
  Tells users which tags each nginx-lua image answers to, so they can pin an exact version or follow a moving alias.

  Background:
    Given Each image comes from a Dockerfile at nginx/<nginx version>/<distro>/<distro version>/Dockerfile, or Dockerfile-compat for the compat variant

  @id:bin.publishing.tagging.004 @rule:publishing.tagging.alpine-claims-short-and-latest-aliases @inferred @source:bin/generate_tags.py#tag_names
  Scenario: An Alpine image is also published under short version aliases and latest
    Given a Dockerfile for nginx 1.25.3 on alpine 3.20
    When the maintainer generates the tags page
    Then the image is listed under 1.25.3-alpine3.20, 1.25.3-alpine, 1.25.3-, 1.25, 1-alpine3.20, alpine, 1-alpine, 1 and latest

  @id:bin.publishing.tagging.005 @rule:publishing.tagging.non-alpine-has-no-bare-aliases @inferred @source:bin/generate_tags.py#tag_names
  Scenario: A non-Alpine image does not take the bare version or latest aliases
    Given a Dockerfile for nginx 1.25.3 on debian 12
    When the maintainer generates the tags page
    Then the image is listed under 1.25.3-debian12, 1.25.3-debian, 1-debian12, debian and 1-debian
    And the image is not listed under 1.25, 1 or latest

  @id:bin.publishing.tagging.006 @rule:publishing.tagging.compat-variant-suffix @inferred @source:bin/generate_tags.py#tag_names
  Scenario: A compat image carries a -compat suffix on every tag
    Given a Dockerfile-compat for nginx 1.25.3 on alpine 3.20
    When the maintainer generates the tags page
    Then every tag for the image ends in -compat, such as 1.25.3-alpine3.20-compat and latest-compat
    And no tag of the compat image is the same as a tag of the standard image

  @id:bin.publishing.tagging.007 @rule:publishing.tagging.amazonlinux-2018-no-distro-alias @inferred @source:bin/generate_tags.py#tag_names
  Scenario: Amazon Linux 2018 never claims the 1-amazonlinux alias
    Given Dockerfiles for amazonlinux 2018.03 and amazonlinux 2023 on nginx 1.25.3
    When the maintainer generates the tags page
    Then 1-amazonlinux appears only on the amazonlinux 2023 image
    And the 2018.03 image keeps 1-amazonlinux2018.03

  @id:bin.publishing.tagging.008 @rule:publishing.tagging.moving-alias-goes-to-latest-dockerfile @inferred @source:bin/generate_tags.py#main @questionable
  Scenario: A tag shared by several images points to the last one in path order
    Given Dockerfiles for alpine 3.19 and alpine 3.20 on nginx 1.25.3
    When the maintainer generates the tags page
    Then alpine, 1-alpine, 1.25, 1 and latest are listed only on the alpine 3.20 entry
    And 1.25.3-alpine3.19 stays on the alpine 3.19 entry
