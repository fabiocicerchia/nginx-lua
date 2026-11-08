@domain:image-build @area:image-layout @from:1-28-1/debian
Feature: Container logs and health reporting
  Gives operators nginx logs in the container log stream and a health state they can orchestrate on.

  Background:
    Given the nginx-lua Debian image is running

  @id:nginx.image-build.image-layout.056 @rule:image.health.unhealthy-when-root-fails @inferred @source:nginx/1.28.1/debian/13.3/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the root page does not answer successfully
    Given nginx does not return a successful response for http://localhost/
    When the orchestrator evaluates the container health check
    Then the container is reported unhealthy after consecutive checks fail (30 second interval, 3 second timeout)
