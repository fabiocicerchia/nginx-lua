@domain:image-build @area:image-layout @from:1-19-8/ubuntu
Feature: Running the nginx 1.19.8 Ubuntu 20.04 image
  Serves operators who deploy the fabiocicerchia/nginx-lua 1.19.8 Ubuntu 20.04 image and rely on its log, health and version-reporting contract.

  Background:
    Given the operator runs the image fabiocicerchia/nginx-lua:1.19.8-ubuntu20.04

  @id:nginx.image-build.image-layout.006 @rule:image.health.unhealthy-when-root-page-fails @inferred @source:nginx/1.19.8/ubuntu/20.04/Dockerfile#HEALTHCHECK @questionable
  Scenario: A container whose root page does not answer successfully is reported unhealthy
    Given the nginx container is running
    When the container platform runs the health check every 30 seconds
    Then the container is reported healthy while http://localhost/ answers with a successful status
    And the container is reported unhealthy when the request fails, returns an HTTP error status, or takes longer than 3 seconds

  @id:nginx.image-build.image-layout.007 @rule:image.metadata.reports-component-versions @inferred @source:nginx/1.19.8/ubuntu/20.04/Dockerfile#LABEL
  Scenario: The image reports the nginx version and bundled component versions in its labels
    Given the image has been built
    When the operator inspects the image labels
    Then the label org.label-schema.version is 1.19.8-ubuntu20.04
    And the label versions.nginx is 1.19.8
    And the label versions.lua-nginx-module is 0.10.19
    And the label versions.luajit2 is 2.1-20201229
    And the label versions.os is 20.04
