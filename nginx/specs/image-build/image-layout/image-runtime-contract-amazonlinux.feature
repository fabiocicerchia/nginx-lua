@domain:image-build @area:image-layout @from:1-31-7/amazonlinux
Feature: Container logging, health and shutdown
  Gives operators the standard container behaviours: logs on docker output, a health probe and graceful stop.

  Background:
    Given Given the amazonlinux nginx-lua image

  @id:nginx.image-build.image-layout.095 @rule:image-build.image-layout.health-and-graceful-stop @inferred @source:nginx/1.31.7/amazonlinux/2023.12.20260930.0/Dockerfile#HEALTHCHECK
  Scenario: The container reports health from port 80 and stops gracefully
    Given the container is running
    When the operator stops the container
    Then nginx receives SIGQUIT and finishes in-flight requests
    And the container health status was based on a successful HTTP request to http://localhost/ every 30 seconds
