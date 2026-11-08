@domain:image-build @area:image-layout @from:1-25-2/fedora
Feature: Operating the container
  Gives operators container logs, health status and graceful shutdown that work with standard Docker tooling.

  Background:
    Given the Fedora 38 image of nginx 1.25.2 with Lua

  @id:nginx.image-build.image-layout.035 @rule:image-build.image-layout.logs-go-to-container-log @inferred @source:nginx/1.25.2/fedora/38/Dockerfile#base
  Scenario: Access and error logs appear in the container log
    Given nginx is running in the container
    When a client requests a page
    Then the access log entry appears in the container's standard output
    And errors appear in the container's standard error

  @id:nginx.image-build.image-layout.036 @rule:image-build.image-layout.health-reflects-root-page @inferred @source:nginx/1.25.2/fedora/38/Dockerfile#base
  Scenario: The container is reported unhealthy when the root page fails
    Given nginx is running in the container
    When the health check requests http://localhost/ every 30 seconds and gets an error or no answer within 3 seconds
    Then the container health status becomes unhealthy
