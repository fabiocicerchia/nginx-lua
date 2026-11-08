@domain:image-build @area:image-layout @from:1-23-1/fedora
Feature: Container logging and health reporting
  Lets operators read nginx logs through Docker and see whether the server is healthy.

  Background:
    Given Given the Fedora 36 image for nginx 1.23.1 with Lua

  @id:nginx.image-build.image-layout.021 @rule:image.logging.forwarded-to-container-output @inferred @source:nginx/1.23.1/fedora/36/Dockerfile#base
  Scenario: Access and error logs appear in the container's log output
    Given the container is running
    When a client requests the default site
    Then the access log line appears in the container's standard output
    And errors appear in the container's standard error

  @id:nginx.image-build.image-layout.022 @rule:image.health.reports-unhealthy-when-default-page-fails @inferred @source:nginx/1.23.1/fedora/36/Dockerfile#base @questionable
  Scenario: The container is reported unhealthy when the local default page fails
    Given the container is running
    When the orchestrator runs the health check every 30 seconds
    Then the container is healthy when http://localhost/ returns a success status
    And the container is unhealthy when the request fails or times out after 3 seconds
