@domain:operations-observability @area:image-metadata @from:1-19-2/alpine
Feature: Identifying what an nginx 1.19.2 Alpine image contains
  Operators and auditors inspect image labels to learn which nginx, OS and bundled component versions an image carries without running it.

  Background:
    Given Given the operator has the nginx 1.19.2 Alpine image built on Alpine <os>

  @id:nginx.operations-observability.image-metadata.017 @rule:ops.metadata.version-label-names-nginx-and-os @inferred @source:nginx/1.19.2/alpine/3.12.0/Dockerfile#LABEL
  Scenario Outline: The image version label combines the nginx version and the Alpine release
    Given the image was built on Alpine <os>
    When the operator inspects the image labels
    Then org.label-schema.version is "<version>"
    And org.label-schema.docker.cmd is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:<version>"
    And versions.os is "<os>"

    Examples:
      | os     | version             |
      | 3.11.6 | 1.19.2-alpine3.11.6 |
      | 3.12.0 | 1.19.2-alpine3.12.0 |
