@domain:image-build @area:image-layout @from:1-30-1/alpine
Feature: Image runtime contract
  Gives operators an image whose logs, ports, health and shutdown behave predictably under Docker.

  Background:
    Given Given the nginx-lua image for Alpine 1.30.1

  @id:nginx.image-build.image-layout.073 @rule:image-build.image-layout.logs-to-docker-and-ports @inferred @source:nginx/1.30.1/alpine/3.23.4/Dockerfile#HEALTHCHECK
  Scenario: The image logs to Docker and exposes web ports with a health check
    Given a container started from the image with default settings
    When the operator inspects the container
    Then access logs go to stdout and error logs to stderr
    And ports 80 and 443 are exposed
    And the health check requests http://localhost/ every 30 seconds with a 3 second timeout
    And the stop signal is SIGQUIT
