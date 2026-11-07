@domain:operations-observability @area:health-and-lifecycle @from:1-18-0/amazonlinux
Feature: Operating the Amazon Linux nginx 1.18.0 container
  Lets operators run, monitor, read logs from and stop the Amazon Linux nginx 1.18.0 container with standard container tooling.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.18.0 Amazon Linux image

  @id:nginx.operations-observability.health-and-lifecycle.022 @rule:operations.amazonlinux.default-run-serves-http @inferred @source:nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile#CMD
  Scenario: Started with no arguments, the container runs nginx in the foreground on ports 80 and 443
    Given no command override is given
    When the operator starts the container with port 80 published
    Then nginx runs in the foreground under the init process
    And an HTTP request to the published port gets a response from nginx
    And the image declares ports 80 and 443

  @id:nginx.operations-observability.health-and-lifecycle.023 @rule:operations.amazonlinux.healthcheck-root-url @inferred @source:nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when nginx stops answering on its root URL
    Given the container has been running for at least 30 seconds
    When the container runtime runs the built-in health check
    Then the check requests http://localhost/ every 30 seconds
    And a request that fails or takes longer than 3 seconds counts as a failed check
    And after repeated failures the container status shows "unhealthy"

  @id:nginx.operations-observability.health-and-lifecycle.024 @rule:operations.amazonlinux.stop-uses-sigterm @inferred @source:nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container sends nginx SIGTERM, a fast shutdown
    Given nginx is serving a long-running request
    When the operator stops the container
    Then nginx receives SIGTERM
    And nginx exits without waiting for in-flight requests to finish

  @id:nginx.operations-observability.health-and-lifecycle.025 @rule:operations.amazonlinux.logs-to-stdio @inferred @source:nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile#RUN
  Scenario: Access logs go to the container's stdout and error logs to its stderr
    Given the default log paths are in use
    When a client requests a page
    Then the access log line appears on the container's stdout
    And nginx errors appear on the container's stderr

  @id:nginx.operations-observability.health-and-lifecycle.026 @rule:operations.amazonlinux.timezone-from-env @inferred @source:nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile#RUN
  Scenario: Setting the TZ environment variable changes the container's local time zone
    Given the TZ environment variable is set to "Europe/Rome"
    When the operator starts the container
    Then log timestamps use the Europe/Rome offset
