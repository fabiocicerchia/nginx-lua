@domain:image-build @area:image-layout @from:1-30-2/alpine
Feature: Image operating behaviour
  Gives operators container logs, health status and graceful shutdown that fit standard container tooling.

  Background:
    Given the nginx-lua alpine image is running

  @id:nginx.image-build.image-layout.075 @rule:image.health.container-reports-health @inferred @source:nginx/1.30.2/alpine/3.23.4/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container is reported unhealthy when the root page cannot be fetched
    Given nginx does not answer http://localhost/ successfully
    When the container platform runs the health check
    Then the check fails and the container is reported unhealthy
