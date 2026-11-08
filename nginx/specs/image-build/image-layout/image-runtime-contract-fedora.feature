@domain:image-build @area:image-layout @from:1-27-1/fedora
Feature: Container logging and health
  Gives operators standard container behaviour: logs in the Docker log collector and a health status.

  Background:
    Given the nginx-lua Fedora 40 image

  @id:nginx.image-build.image-layout.049 @rule:image.health.http-probe @inferred @source:nginx/1.27.1/fedora/40/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when the local site does not answer successfully
    Given a running container
    When the operator inspects container health
    Then health is checked every 30 seconds with a 3 second timeout
    And the container is unhealthy if http://localhost/ returns an error status or no answer
