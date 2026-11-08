@domain:image-build @area:image-layout @from:1-23-1/ubuntu
Feature: Logging, health and shutdown of the running container
  Gives operators the container behaviours they rely on to monitor and stop nginx under Docker.

  Background:
    Given the nginx-lua Ubuntu 22.04 image running nginx 1.23.1

  @id:nginx.image-build.image-layout.023 @rule:image.health.container-unhealthy-when-root-fails @inferred @source:nginx/1.23.1/ubuntu/22.04/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container is reported unhealthy when the root page does not answer successfully
    Given nginx does not return a success status for http://localhost/
    When the container runtime runs its 30 second health check
    Then the check fails after at most 3 seconds
    And after consecutive failed checks the container is reported unhealthy

  @id:nginx.image-build.image-layout.024 @rule:image.shutdown.stop-is-graceful @inferred @source:nginx/1.23.1/ubuntu/22.04/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets in-flight requests finish
    Given nginx is serving requests
    When the operator stops the container
    Then the container receives SIGQUIT
    And nginx finishes current requests before exiting
