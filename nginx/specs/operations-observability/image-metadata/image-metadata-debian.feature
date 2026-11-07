@domain:operations-observability @area:image-metadata @from:1-19-4/debian
Feature: Reading image metadata
  Lets operators and tooling see which nginx, OS and module versions an image contains without running it.

  Background:
    Given the nginx-lua 1.19.4 Debian 10.6 image has been built

  @id:nginx.operations-observability.image-metadata.032 @rule:image.metadata.labels-carry-versions @inferred @source:nginx/1.19.4/debian/10.6/Dockerfile#LABEL @questionable
  Scenario Outline: Image labels do not report the bundled versions
    Given the build passed BUILD_DATE "2020-11-01T00:00:00Z" and VCS_REF "abc1234"
    When the operator inspects the image labels
    Then label "<label>" is empty

    Examples:
      | label                       |
      | versions.nginx              |
      | versions.lua-nginx-module   |
      | versions.os                 |
      | org.label-schema.build-date |
      | org.label-schema.vcs-ref    |
