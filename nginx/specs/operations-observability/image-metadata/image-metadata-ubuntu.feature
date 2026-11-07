@domain:operations-observability @area:image-metadata @from:1-19-4/ubuntu
Feature: Publishing image metadata
  Lets operators and tooling find out which nginx, OS and module versions an image contains without running it.

  @id:nginx.operations-observability.image-metadata.034 @rule:operations.metadata.labels-carry-versions @inferred @source:nginx/1.19.4/ubuntu/20.04/Dockerfile#LABEL @questionable
  Scenario: Image labels do not carry the bundled component versions
    Given the nginx 1.19.4 Ubuntu 20.04 image has been built
    When the operator inspects the image labels
    Then "versions.nginx" is empty instead of "1.19.4"
    And "org.label-schema.version" is "-" instead of "1.19.4-ubuntu20.04"
    And "versions.lua-nginx-module", "versions.luajit2" and the other "versions.*" labels are empty
