@domain:operations-observability @area:health-and-lifecycle @from:1-19-10/alpine
Feature: Container health, logs and shutdown
  Gives operators and orchestrators a health signal, logs on the container's output and a graceful stop, so they can run the image without extra setup.

  Background:
    Given the container image nginx-lua 1.19.10 on Alpine 3.13

  @id:nginx.operations-observability.health-and-lifecycle.075 @rule:container.lifecycle.healthcheck-on-local-http @inferred @source:nginx/1.19.10/alpine/3.13.5/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when its local HTTP port stops answering
    Given the container is running with its default command
    When the container runtime runs the built-in health check
    Then the container is healthy while http://localhost/ answers with a success status within 3 seconds
    And the container is unhealthy when that request fails or returns an error status
    And the check repeats every 30 seconds

  @id:nginx.operations-observability.health-and-lifecycle.076 @rule:container.lifecycle.graceful-stop @inferred @source:nginx/1.19.10/alpine/3.13.5/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets nginx finish in-flight requests
    Given the container is serving requests
    When the operator stops the container
    Then nginx receives SIGQUIT and shuts down gracefully, finishing open requests instead of dropping them

  @id:nginx.operations-observability.health-and-lifecycle.077 @rule:container.lifecycle.logs-to-container-output @inferred @source:nginx/1.19.10/alpine/3.13.5/Dockerfile#RUN
  Scenario: Access and error logs appear on the container's output
    Given the container is running with the shipped config
    When a client requests http://localhost/
    Then the access log line appears on the container's stdout
    And nginx error messages appear on the container's stderr
