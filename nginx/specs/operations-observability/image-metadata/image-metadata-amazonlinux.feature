@domain:operations-observability @area:image-metadata @from:1-19-4/amazonlinux
Feature: Describing the image through labels
  Operators and tooling read image labels to learn the build date, source revision and bundled component versions.

  Background:
    Given the nginx-lua Amazon Linux 2 image for nginx 1.19.4 has been built

  @id:nginx.operations-observability.image-metadata.029 @rule:image.metadata.labels-list-component-versions @inferred @source:nginx/1.19.4/amazonlinux/2.0.20200722.0/Dockerfile#LABEL @questionable
  Scenario Outline: Image labels carry empty build and component versions
    Given the image was built with BUILD_DATE "2026-11-07T10:00:00Z" and VCS_REF "abc1234"
    When the operator inspects the image labels
    Then the label "<label>" reads "<value>"

    Examples:
      | label                       | value                                    |
      | maintainer                  | Fabio Cicerchia <info@fabiocicerchia.it> |
      | org.label-schema.build-date |                                          |
      | org.label-schema.vcs-ref    |                                          |
      | versions.nginx              |                                          |
      | versions.lua-nginx-module   |                                          |
      | org.label-schema.version    | -                                        |
