@domain:operations-observability @area:image-metadata @from:1-19-0/alpine
Feature: Image metadata for the nginx 1.19.0 Alpine images
  Operators and scanners read image labels to find the nginx, OS and component versions inside an image without running it.

  @id:nginx.operations-observability.image-metadata.004 @rule:image.metadata.component-version-labels @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#LABEL
  Scenario Outline: Newer variants label every bundled component version, older ones do not
    Given the operator has pulled the <alpine> variant
    When the operator inspects the image labels
    Then org.label-schema.version is <schema_version>
    And per-component versions.* labels (nginx, luajit2, lua-nginx-module, os, ...) are <component_labels>

    Examples:
      | alpine | schema_version                                           | component_labels |
      | 3.12.0 | 1.19.0-alpine3.12.0                                      | present          |
      | 3.11.6 | 1.19.0-alpine3.11.6                                      | present          |
      | 3.11.5 | the BUILD_VERSION build argument (empty when not passed) | absent           |
      | 3.10.5 | the BUILD_VERSION build argument (empty when not passed) | absent           |
