@domain:operations-observability @area:health-and-lifecycle @from:1-19-2/alpine
Feature: Running the nginx 1.19.2 Alpine container
  Operators who run the nginx 1.19.2 Alpine image rely on how it starts, reports health, logs, and stops so they can orchestrate it like any other container.

  Background:
    Given Given the operator runs a container from the nginx 1.19.2 Alpine image

  @id:nginx.operations-observability.health-and-lifecycle.091 @rule:ops.container.healthcheck-probes-http-root @inferred @source:nginx/1.19.2/alpine/3.12.0/Dockerfile#HEALTHCHECK
  Scenario: The container reports healthy only while nginx answers on port 80
    Given the default configuration is in place
    When the container runtime runs the built-in health check
    Then it requests http://localhost/ every 30 seconds with a 3 second timeout
    And the container is marked unhealthy when that request fails or returns an HTTP error status

  @id:nginx.operations-observability.health-and-lifecycle.092 @rule:ops.container.graceful-stop-on-sigquit @inferred @source:nginx/1.19.2/alpine/3.12.0/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container shuts nginx down gracefully
    Given nginx is serving requests
    When the operator stops the container
    Then the container receives SIGQUIT instead of SIGTERM
    And nginx finishes in-flight requests before exiting

  @id:nginx.operations-observability.health-and-lifecycle.093 @rule:ops.container.default-command-runs-nginx-foreground @inferred @source:nginx/1.19.2/alpine/3.12.0/Dockerfile#ENTRYPOINT @questionable
  Scenario: By default the container runs nginx in the foreground under a minimal init
    Given the operator passes no command
    When the container starts
    Then the main process is dumb-init running "nginx -g 'daemon off;'"
    And the container listens on the exposed ports 80 and 443
