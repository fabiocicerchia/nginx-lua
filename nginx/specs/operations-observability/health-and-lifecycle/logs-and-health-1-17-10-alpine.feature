@domain:operations-observability @area:health-and-lifecycle @from:1-17-10/alpine
Feature: Logs, health and shutdown for nginx 1.17.10 Alpine
  Operators and orchestrators read nginx logs from the container streams, see whether the container is healthy, and stop it with Docker's stop signal.

  Background:
    Given the operator runs an nginx-lua 1.17.10 Alpine image

  @id:nginx.operations-observability.health-and-lifecycle.001 @rule:logging.container.logs-to-stdio @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#RUN
  Scenario: Access and error logs appear on the container's output streams
    Given the configuration uses the default access and error log paths
    When a client requests "/missing-page"
    Then an access log line for "/missing-page" with status 404 appears on the container's stdout
    And the matching "open() ... failed" error line appears on the container's stderr

  @id:nginx.operations-observability.health-and-lifecycle.002 @rule:lifecycle.healthcheck.http-root-probe @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is healthy only while http://localhost/ answers with a success status
    Given the container's site at http://localhost/ answers with status <status>
    When the orchestrator runs the built-in health check
    Then the container's health status is "<health>"

    Examples:
      | status                     | health    |
      | 200                        | healthy   |
      | 404                        | unhealthy |
      | no answer within 3 seconds | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.003 @rule:lifecycle.ports.http-https-exposed @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#EXPOSE
  Scenario: The image declares the HTTP and HTTPS ports
    When the operator inspects the image
    Then ports 80/tcp and 443/tcp are listed as exposed

  @id:nginx.operations-observability.health-and-lifecycle.004 @rule:lifecycle.shutdown.sigterm-fast-stop @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container makes nginx exit immediately without finishing in-flight requests
    Given a client download is in progress
    When the operator stops the container
    Then nginx receives SIGTERM
    And nginx exits at once and the in-progress download is cut off
