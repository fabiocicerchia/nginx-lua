@domain:image-build @area:image-layout @from:1-25-5/alpine
Feature: Alpine image runtime contract
  Operators running the alpine image expect logs on the container streams, ports exposed, health reporting and graceful shutdown.

  Background:
    Given Given the nginx-lua alpine image

  @id:nginx.image-build.image-layout.047 @rule:image.health.reported-by-fetching-root @inferred @source:nginx/1.25.5/alpine/3.19.1/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when the root page fails
    Given the container is running
    When the orchestrator runs the 30-second health check
    Then the container is healthy if http://localhost/ returns a success status
    And the container is unhealthy after a failed check or a 3 second timeout

  @id:nginx.image-build.image-layout.048 @rule:image.shutdown.graceful-quit @inferred @source:nginx/1.25.5/alpine/3.19.1/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container asks nginx to finish in-flight requests
    Given the container is serving requests
    When the operator stops the container
    Then nginx receives SIGQUIT and shuts down gracefully
