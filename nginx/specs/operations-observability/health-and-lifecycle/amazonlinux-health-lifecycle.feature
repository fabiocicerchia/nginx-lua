@domain:operations-observability @area:health-and-lifecycle @from:1-19-2/amazonlinux
Feature: Container health and shutdown
  Operators running the nginx 1.19.2 Amazon Linux 2 image need the orchestrator to see its health, reach its ports and stop it without dropping in-flight requests.

  Background:
    Given the operator runs the nginx-lua 1.19.2 Amazon Linux 2 image with its default configuration

  @id:nginx.operations-observability.health-and-lifecycle.094 @rule:operations.health.healthcheck-probes-local-http @inferred @source:nginx/1.19.2/amazonlinux/2.0.20200722.0/Dockerfile#HEALTHCHECK
  Scenario Outline: The container reports healthy only while the local HTTP site answers
    Given the container has been running for at least one healthcheck interval of 30 seconds
    When the container runtime runs the built-in healthcheck
    Then it requests http://localhost/ with a 3 second timeout
    And the container is reported as <state> when that request <result>

    Examples:
      | result                      | state                                     |
      | returns a 2xx or 3xx status | healthy                                   |
      | returns a 4xx or 5xx status | unhealthy after the runtime's retry count |
      | times out or is refused     | unhealthy after the runtime's retry count |

  @id:nginx.operations-observability.health-and-lifecycle.096 @rule:operations.lifecycle.exposes-http-and-https-ports @inferred @source:nginx/1.19.2/amazonlinux/2.0.20200722.0/Dockerfile#EXPOSE
  Scenario: The image declares the HTTP and HTTPS ports
    When the operator inspects the image
    Then ports 80 and 443 are declared as exposed
