@domain:image-build @area:image-layout @from:1-23-3/alpine
Feature: Image runtime layout
  Gives operators a container that logs to the Docker log collector, advertises its ports and reports its health.

  Background:
    Given Given an nginx-lua Alpine image 1.23.3-alpine3.17

  @id:nginx.image-build.image-layout.025 @rule:image-build.image-layout.http-health-and-ports @inferred @source:nginx/1.23.3/alpine/3.17.2/Dockerfile#HEALTHCHECK
  Scenario: The container exposes ports 80 and 443 and is unhealthy when the root page fails
    Given the container is running
    When the operator checks the container health
    Then ports 80 and 443 are declared
    And the container is healthy while http://localhost/ answers with a success status
    And the check runs every 30 seconds with a 3 second timeout
