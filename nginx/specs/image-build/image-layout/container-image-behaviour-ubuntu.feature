@domain:image-build @area:image-layout @from:1-28-3/ubuntu
Feature: Operating the nginx image
  What an operator sees when running and supervising the container: logs, health and shutdown.

  Background:
    Given Image fabiocicerchia/nginx-lua on Ubuntu 24.04 exposes ports 80 and 443

  @id:nginx.image-build.image-layout.057 @rule:image.health.reports-unhealthy-when-home-page-fails @inferred @source:nginx/1.28.3/ubuntu/24.04/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the home page fails
    Given the container is running
    When the orchestrator runs the 30-second health probe and http://localhost/ returns an error or takes over 3 seconds
    Then the probe fails and the container is marked unhealthy

  @id:nginx.image-build.image-layout.058 @rule:image.stop.graceful-shutdown @inferred @source:nginx/1.28.3/ubuntu/24.04/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container shuts nginx down gracefully
    Given the container is serving requests
    When the operator stops the container
    Then nginx receives SIGQUIT and finishes in-flight requests before exiting
