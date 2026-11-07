@domain:operations-observability @area:health-and-lifecycle @from:1-19-4/ubuntu
Feature: Running, monitoring and stopping the container
  Gives operators a container that runs nginx in the foreground, reports its health, sends logs to the container log and shuts down gracefully.

  Background:
    Given the operator runs the nginx 1.19.4 Ubuntu 20.04 image

  @id:nginx.operations-observability.health-and-lifecycle.151 @rule:operations.lifecycle.default-command-runs-nginx-foreground @inferred @source:nginx/1.19.4/ubuntu/20.04/Dockerfile#CMD
  Scenario: Without a command the container runs nginx in the foreground on ports 80 and 443
    Given no command is given
    When the operator starts the container
    Then nginx runs with "daemon off;" as the container's main process
    And the image declares ports 80 and 443

  @id:nginx.operations-observability.health-and-lifecycle.153 @rule:operations.lifecycle.healthcheck-on-local-http @inferred @source:nginx/1.19.4/ubuntu/20.04/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is unhealthy when the local site does not answer successfully
    Given nginx inside the container answers "http://localhost/" with <status>
    When the container runtime runs the health check
    Then the container is reported <health>

    Examples:
      | status                       | health    |
      | 200                          | healthy   |
      | 500                          | unhealthy |
      | no response within 3 seconds | unhealthy |
