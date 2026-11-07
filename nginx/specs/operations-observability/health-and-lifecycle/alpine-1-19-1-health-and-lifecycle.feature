@domain:operations-observability @area:health-and-lifecycle @from:1-19-1/alpine
Feature: Container health and shutdown
  Orchestrators and operators rely on the image's built-in healthcheck, published ports and stop signal to supervise nginx.

  Background:
    Given Given a container started from an nginx-lua 1.19.1 Alpine image

  @id:nginx.operations-observability.health-and-lifecycle.059 @rule:operations.lifecycle.healthcheck-probes-home-page @inferred @source:nginx/1.19.1/alpine/3.12.0/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is healthy only while the home page answers with a non-error status
    Given requests to http://localhost/ inside the container return <response>
    When the container runtime runs the built-in healthcheck
    Then the container is reported <health>

    Examples:
      | response                   | health    |
      | 200 OK within 3 seconds    | healthy   |
      | 500 Internal Server Error  | unhealthy |
      | no answer within 3 seconds | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.060 @rule:operations.lifecycle.graceful-stop-on-sigquit @inferred @source:nginx/1.19.1/alpine/3.12.0/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container shuts nginx down gracefully
    Given nginx is serving a request that is still in progress
    When the operator stops the container
    Then nginx receives SIGQUIT
    And the in-progress request is completed before nginx exits

  @id:nginx.operations-observability.health-and-lifecycle.061 @rule:operations.lifecycle.web-ports-exposed @inferred @source:nginx/1.19.1/alpine/3.12.0/Dockerfile#EXPOSE
  Scenario: The image declares the HTTP and HTTPS ports
    Given the operator inspects the image
    When the operator lists the exposed ports
    Then ports 80/tcp and 443/tcp are listed
