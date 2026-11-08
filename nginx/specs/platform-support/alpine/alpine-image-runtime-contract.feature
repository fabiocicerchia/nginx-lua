@domain:platform-support @area:alpine @from:1-19-1/alpine
Feature: Running the Alpine nginx 1.19.1 image
  Operators running the nginx 1.19.1 Lua image on Alpine rely on it logging to the container log, reporting health and stopping gracefully.

  Background:
    Given Given the operator runs the fabiocicerchia/nginx-lua image tagged 1.19.1-alpine3.12.0

  @id:nginx.platform-support.alpine.013 @rule:image.runtime.health-reported-by-root-page @inferred @source:nginx/1.19.1/alpine/3.12.0/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container is reported unhealthy when the web server does not answer
    Given the container is running
    When the container runtime runs its periodic health check
    Then the container is healthy when http://localhost/ returns a success status
    And the container is unhealthy when the request fails or takes more than 3 seconds

  @id:nginx.platform-support.alpine.014 @rule:image.runtime.graceful-stop @inferred @source:nginx/1.19.1/alpine/3.12.0/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets nginx finish in-flight requests
    Given the container is running and serving requests
    When the operator stops the container
    Then nginx receives a graceful quit signal and completes active requests before exiting
