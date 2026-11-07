@domain:operations-observability @area:image-metadata @from:1-19-10/amazonlinux
Feature: Image metadata labels
  Lets operators and inventory tools see which nginx, OS and bundled component versions an image contains without running it.

  Background:
    Given the nginx-lua 1.19.10 Amazon Linux 2 image has been pulled

  @id:nginx.operations-observability.image-metadata.012 @rule:operations.metadata.version-labels @inferred @source:nginx/1.19.10/amazonlinux/2.0.20210326.0/Dockerfile#LABEL
  Scenario: The image labels list the nginx, OS and bundled component versions
    Given the image was built with the default build settings
    When the operator inspects the image labels
    Then "versions.nginx" is "1.19.10"
    And "versions.os" is "2.0.20210326.0"
    And "versions.lua-nginx-module" is "0.10.19" and "versions.luajit2" is "2.1-20201229"
    And "org.label-schema.version" is "1.19.10-amazonlinux2.0.20210326.0"
