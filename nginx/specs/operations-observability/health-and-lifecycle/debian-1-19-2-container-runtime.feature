@domain:operations-observability @area:health-and-lifecycle @from:1-19-2/debian
Feature: Running the nginx 1.19.2 Debian slim container
  Operators who deploy the Debian 10.4/10.5-slim nginx 1.19.2 images rely on a fixed runtime contract (health probe, ports, stop signal, logs, default command) to run them under Docker or an orchestrator.

  Background:
    Given the operator runs a nginx-lua 1.19.2 Debian slim image (10.4-slim or 10.5-slim) with its default configuration

  @id:nginx.operations-observability.health-and-lifecycle.097 @rule:image.health.http-probe-on-localhost @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when nginx stops answering on port 80
    Given the container has been running for at least 30 seconds
    When the container runtime probes the container's health
    Then the probe requests http://localhost/ inside the container
    And the container is reported healthy when the response is a success status
    And the container is reported unhealthy when the request fails or takes longer than 3 seconds

  @id:nginx.operations-observability.health-and-lifecycle.098 @rule:image.network.exposes-http-and-https @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#EXPOSE
  Scenario: The image advertises HTTP and HTTPS ports
    When the operator inspects the image's exposed ports
    Then port 80 is exposed
    And port 443 is exposed

  @id:nginx.operations-observability.health-and-lifecycle.099 @rule:image.lifecycle.graceful-stop-on-sigquit @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets nginx finish in-flight requests
    Given nginx is serving a long-running request
    When the operator stops the container
    Then the container runtime sends SIGQUIT instead of SIGTERM
    And dumb-init forwards the signal to nginx
    And nginx stops accepting new connections and exits after in-flight requests complete

  @id:nginx.operations-observability.health-and-lifecycle.100 @rule:image.logging.access-and-error-to-stdio @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#RUN
  Scenario: Access and error logs show up in the container logs
    When a client sends a request to the container
    Then the access log entry appears on the container's standard output
    And nginx error messages appear on the container's standard error
    And no log files build up inside the container

  @id:nginx.operations-observability.health-and-lifecycle.101 @rule:image.runtime.foreground-nginx-under-dumb-init @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#ENTRYPOINT
  Scenario: By default the container runs nginx in the foreground under a minimal init
    When the operator starts the container without a command
    Then dumb-init runs as the container's main process
    And nginx runs with 'daemon off;' so the container stays up as long as nginx does
    And worker processes run as the nginx user with uid 32548 and gid 32548

  @id:nginx.operations-observability.health-and-lifecycle.102 @rule:image.runtime.timezone-from-tz @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#RUN
  Scenario: The operator can set the container's timezone through TZ
    Given the operator sets TZ to "Europe/Rome"
    When the operator starts the container
    Then log timestamps and nginx local-time values use the Europe/Rome timezone
