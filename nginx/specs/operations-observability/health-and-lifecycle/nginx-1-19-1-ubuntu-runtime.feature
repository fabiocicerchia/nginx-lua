@domain:operations-observability @area:health-and-lifecycle @from:1-19-1/ubuntu
Feature: Running the nginx 1.19.1 Ubuntu container
  Operators running the nginx 1.19.1 Ubuntu 20.04/20.10 images rely on a predictable start command, health probe, stop behaviour, log destination and worker identity.

  Background:
    Given an operator runs a container from the nginx 1.19.1 Ubuntu image with its default settings

  @id:nginx.operations-observability.health-and-lifecycle.070 @rule:images.lifecycle.healthcheck-probes-root @inferred @source:nginx/1.19.1/ubuntu/20.04/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is reported unhealthy when the root page stops answering
    Given the container has been running for at least one probe interval
    And the site root answers with status <status>
    When the container runtime probes the container's health
    Then the probe requests http://localhost/ every 30 seconds with a 3 second timeout
    And the container is reported <health>

    Examples:
      | status              | health    |
      | 200                 | healthy   |
      | 404                 | unhealthy |
      | 500                 | unhealthy |
      | no answer within 3s | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.071 @rule:images.lifecycle.sigquit-graceful-stop @inferred @source:nginx/1.19.1/ubuntu/20.04/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container shuts nginx down gracefully
    Given nginx is serving a long-running request
    When the operator stops the container
    Then nginx receives SIGQUIT
    And the in-flight request is allowed to finish before nginx exits

  @id:nginx.operations-observability.health-and-lifecycle.072 @rule:images.logging.logs-to-container-output @inferred @source:nginx/1.19.1/ubuntu/20.04/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's output
    Given a client requests a page from the container
    When the operator reads the container logs
    Then the access log line appears on the container's stdout
    And error log lines appear on the container's stderr

  @id:nginx.operations-observability.health-and-lifecycle.073 @rule:images.runtime.default-command-foreground @inferred @source:nginx/1.19.1/ubuntu/20.04/Dockerfile#CMD
  Scenario: The container serves on ports 80 and 443 with nginx in the foreground
    Given the operator gives no command of their own
    When the operator starts the container
    Then nginx runs in the foreground under dumb-init with "daemon off;"
    And the image declares ports 80 and 443
    And the shipped configuration passes nginx's own config test
