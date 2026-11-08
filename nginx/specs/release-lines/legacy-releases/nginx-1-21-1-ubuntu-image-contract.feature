@domain:release-lines @area:legacy-releases @from:1-21-1/ubuntu
Feature: Running the nginx 1.21.1 Ubuntu 20.04 image
  Operators who deploy the nginx-lua image on Ubuntu 20.04 rely on its logging, ports, health reporting, shutdown and identity labels behaving the same way as the other images.

  Background:
    Given Given the image fabiocicerchia/nginx-lua:1.21.1-ubuntu20.04 is running as a container

  @id:nginx.release-lines.legacy-releases.004 @rule:image.metadata.labels-report-component-versions @inferred @source:nginx/1.21.1/ubuntu/20.04/Dockerfile#LABEL
  Scenario: The image labels report the nginx, OS and Lua component versions
    Given the image metadata is inspected
    When the operator reads the image labels
    Then the version label is 1.21.1-ubuntu20.04
    And the label versions.nginx is 1.21.1
    And the label versions.lua-nginx-module is 0.10.20
    And the label versions.os is 20.04
