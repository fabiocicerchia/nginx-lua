@domain:operations-observability @area:health-and-lifecycle @from:1-18-0/debian
Feature: Operating nginx 1.18.0 Debian slim containers
  For operators who run these containers under Docker and depend on health status, logs on the container streams, stop behaviour and timezone settings.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.18.0 Debian slim container

  @id:nginx.operations-observability.health-and-lifecycle.029 @rule:ops.health.healthcheck-probes-default-site @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#HEALTHCHECK @questionable
  Scenario: The built-in healthcheck reports the container unhealthy even when nginx is serving
    Given nginx is serving 200 on http://localhost/ inside the container
    When Docker runs the built-in healthcheck (every 30s, 3s timeout)
    Then the probe fails because curl is not installed in the image
    And after the default three failed probes the container's health status is "unhealthy"

  @id:nginx.operations-observability.health-and-lifecycle.030 @rule:ops.logging.logs-to-container-streams @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#RUN
  Scenario: Access and error logs appear on the container's output streams
    Given nginx uses the default log paths
    When a client requests a page that does not exist
    Then an access log line for the request appears on the container's stdout
    And the "open() ... failed" error line appears on the container's stderr

  @id:nginx.operations-observability.health-and-lifecycle.031 @rule:ops.lifecycle.stop-is-fast-shutdown @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container shuts nginx down at once and cuts in-flight requests
    Given a client has a long download in progress
    When the operator stops the container
    Then nginx gets SIGTERM and exits without waiting for open requests
    And the client's download is cut off

  @id:nginx.operations-observability.health-and-lifecycle.032 @rule:ops.time.timezone-from-tz-env @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#RUN
  Scenario: The operator sets the container timezone with the TZ variable
    Given the operator sets TZ to Europe/Rome
    When the operator starts the container
    Then log timestamps are in Europe/Rome local time
