@domain:operations-observability @area:image-metadata @from:1-19-3/alpine
Feature: Image version labels
  Lets operators and tooling read which nginx, OS and bundled component versions an image contains without running it.

  @id:nginx.operations-observability.image-metadata.024 @rule:image.metadata.version-labels-populated @inferred @source:nginx/1.19.3/alpine/3.12.1/Dockerfile#LABEL @questionable
  Scenario Outline: Image labels for build date, revision and component versions are empty
    Given the operator has the nginx 1.19.3 image on Alpine 3.12.1
    When the operator inspects the image labels
    Then the label <label> has the value "<value>"

    Examples:
      | label                       | value |
      | versions.nginx              |       |
      | versions.lua-nginx-module   |       |
      | versions.os                 |       |
      | org.label-schema.version    | -     |
      | org.label-schema.build-date |       |
