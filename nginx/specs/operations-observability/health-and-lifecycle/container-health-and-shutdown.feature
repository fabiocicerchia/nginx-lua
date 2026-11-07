@domain:operations-observability @area:health-and-lifecycle @from:1-19-10/ubuntu
Feature: Container health and shutdown
  Gives orchestrators a health signal, the ports to publish and a graceful stop for the nginx-lua container.

  Background:
    Given the operator runs the nginx-lua 1.19.10 Ubuntu 20.04 image

  @id:nginx.operations-observability.health-and-lifecycle.087 @rule:operations.health.http-healthcheck @inferred @source:nginx/1.19.10/ubuntu/20.04/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is healthy only while the local site answers with success
    Given the site at http://localhost/ answers with status <status>
    When the container runtime runs the built-in health check (every 30 seconds, 3-second timeout)
    Then the container is reported as <health>

    Examples:
      | status | health    |
      | 200    | healthy   |
      | 404    | unhealthy |
      | 502    | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.088 @rule:operations.health.default-site-has-no-content @inferred @source:nginx/1.19.10/ubuntu/20.04/tpl/default.conf#server @questionable
  Scenario: With the shipped configuration the default site has no page to serve, so the container reports unhealthy
    Given the operator uses the shipped nginx and default site configuration
    When a client requests http://localhost/
    Then the response status is 404
    And the container runtime reports the container as unhealthy

  @id:nginx.operations-observability.health-and-lifecycle.090 @rule:operations.lifecycle.exposed-ports @inferred @source:nginx/1.19.10/ubuntu/20.04/Dockerfile#EXPOSE
  Scenario: The image declares the HTTP and HTTPS ports
    When the operator inspects the image
    Then the exposed ports are 80/tcp and 443/tcp
