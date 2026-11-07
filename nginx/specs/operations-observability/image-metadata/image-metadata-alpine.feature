@domain:operations-observability @area:image-metadata @from:1-19-4/alpine
Feature: Describing the image through labels
  Lets operators and tooling see which nginx, OS and bundled component versions an image contains without running it.

  Background:
    Given the nginx-lua 1.19.4 Alpine 3.12.1 image built with BUILD_DATE and VCS_REF supplied

  @id:nginx.operations-observability.image-metadata.028 @rule:observability.metadata.version-labels @inferred @source:nginx/1.19.4/alpine/3.12.1/Dockerfile#LABEL @questionable
  Scenario Outline: Version labels on the image are empty
    Given the image was built from this Dockerfile
    When the operator inspects the image labels
    Then "<label>" is present with an empty value instead of "<expected>"

    Examples:
      | label                       | expected                |
      | versions.nginx              | 1.19.4                  |
      | versions.lua-nginx-module   | 0.10.17                 |
      | versions.luajit2            | 2.1-20201012-2          |
      | org.label-schema.build-date | the supplied BUILD_DATE |
      | org.label-schema.version    | 1.19.4-alpine3.12.1     |
