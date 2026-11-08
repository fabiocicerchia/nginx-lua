@domain:image-build @area:image-layout @from:1-29-5/debian
Feature: Logging and health of the running image
  Lets operators collect nginx logs with Docker and see container health.

  Background:
    Given the nginx-lua Debian image 1.29.5 is running

  @id:nginx.image-build.image-layout.068 @rule:image.health.reports-http-root @inferred @source:nginx/1.29.5/debian/13.3/Dockerfile#HEALTHCHECK
  Scenario: The container is reported healthy only while http://localhost/ answers successfully
    Given the container has been running
    When the operator checks the container health
    Then health is checked every 30 seconds with a 3 second timeout
    And the container is unhealthy when GET http://localhost/ fails or returns an error status
