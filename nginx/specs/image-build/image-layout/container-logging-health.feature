@domain:image-build @area:image-layout @from:1-19-3/amazonlinux
Feature: Container logging and health
  Lets operators observe nginx through standard Docker tooling.

  Background:
    Given Given the nginx 1.19.3 Amazon Linux 2.0.20200722.0 image

  @id:nginx.image-build.image-layout.001 @rule:image-layout.health.container-reports-health @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the home page does not respond successfully
    Given a running container whose http://localhost/ returns an error status
    When the operator inspects the container health after repeated 30 second checks
    Then the health status is unhealthy
