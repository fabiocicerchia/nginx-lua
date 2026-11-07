@domain:operations-observability @area:health-and-lifecycle @from:1-19-3/fedora
Feature: Container health, ports and shutdown
  Gives operators and orchestrators a working health signal, known ports and a graceful stop for nginx-lua Fedora containers.

  Background:
    Given a container from the nginx-lua 1.19.3 Fedora image

  @id:nginx.operations-observability.health-and-lifecycle.125 @rule:container.health.home-page-probe @inferred @source:nginx/1.19.3/fedora/33/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is reported healthy only while its home page answers
    Given a request to http://localhost/ inside the container returns <response>
    When the container runtime runs the built-in health check (every 30 seconds, 3-second timeout)
    Then the check <result>

    Examples:
      | response                   | result                                                  |
      | 200 OK                     | passes and the container stays healthy                  |
      | 404 Not Found              | fails and counts toward marking the container unhealthy |
      | no answer within 3 seconds | fails and counts toward marking the container unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.127 @rule:container.lifecycle.default-run @inferred @source:nginx/1.19.3/fedora/33/Dockerfile#CMD
  Scenario: By default the container runs nginx in the foreground on ports 80 and 443
    Given no command is given
    When the operator runs the image
    Then nginx runs as the container's main process with "daemon off;"
    And the image declares ports 80 and 443
    And the default page answers on port 80
