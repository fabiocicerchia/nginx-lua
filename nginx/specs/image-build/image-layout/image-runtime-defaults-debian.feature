@domain:image-build @area:image-layout @from:1-25-4/debian
Feature: Image runtime defaults
  Gives operators an image that exposes web ports, logs to Docker and reports its own health.

  Background:
    Given Given the nginx-lua Debian 12.5 image for nginx 1.25.4

  @id:nginx.image-build.image-layout.045 @rule:image-build.image-layout.logs-to-container-output @inferred @source:nginx/1.25.4/debian/12.5/Dockerfile#base
  Scenario: Access and error logs appear in the container's standard output and error
    Given the container is running with the default configuration
    When a client requests http://localhost/
    Then the access log line appears in the container's standard output
    And errors appear in the container's standard error

  @id:nginx.image-build.image-layout.046 @rule:image-build.image-layout.healthcheck @inferred @source:nginx/1.25.4/debian/12.5/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the site stops answering on port 80
    Given the container is running
    When the orchestrator runs the 30-second health probe and http://localhost/ fails
    Then the probe fails after 3 seconds at most
    And the container is reported unhealthy
