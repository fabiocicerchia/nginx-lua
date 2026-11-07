@domain:operations-observability @area:health-and-lifecycle @from:1-19-4/alpine
Feature: Container health and shutdown
  Gives orchestrators a built-in health signal, declared ports and a graceful stop for the running container.

  Background:
    Given the nginx-lua 1.19.4 Alpine 3.12.1 image

  @id:nginx.operations-observability.health-and-lifecycle.131 @rule:observability.lifecycle.healthcheck-root-url @inferred @source:nginx/1.19.4/alpine/3.12.1/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is reported unhealthy when the root page does not answer
    Given the container is running
    And GET http://localhost/ inside the container returns <status>
    When the container runtime runs the health check
    Then the container is reported <health>

    Examples:
      | status                     | health                                    |
      | 200                        | healthy                                   |
      | 500                        | unhealthy after the retries are exhausted |
      | no answer within 3 seconds | unhealthy after the retries are exhausted |

  @id:nginx.operations-observability.health-and-lifecycle.132 @rule:observability.lifecycle.graceful-stop @inferred @source:nginx/1.19.4/alpine/3.12.1/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets in-flight requests finish
    Given the container is serving a long-running request
    When the operator stops the container
    Then nginx receives SIGQUIT
    And the in-flight request completes before nginx exits

  @id:nginx.operations-observability.health-and-lifecycle.133 @rule:observability.lifecycle.exposed-ports @inferred @source:nginx/1.19.4/alpine/3.12.1/Dockerfile#EXPOSE
  Scenario: The image declares ports 80 and 443
    Given the image is inspected
    When the operator runs the container with all exposed ports published
    Then ports 80 and 443 are published
