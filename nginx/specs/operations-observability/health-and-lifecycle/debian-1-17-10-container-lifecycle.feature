@domain:operations-observability @area:health-and-lifecycle @from:1-17-10/debian
Feature: Running and stopping the nginx 1.17.10 Debian container
  Operators running the Debian-based nginx 1.17.10 images need to know what the container reports about its health, which ports it serves on, and how it starts and stops.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.17.10 Debian slim image with its default configuration

  @id:nginx.operations-observability.health-and-lifecycle.008 @rule:images.lifecycle.healthcheck-probes-local-http @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#HEALTHCHECK @questionable
  Scenario: The built-in healthcheck reports the container unhealthy because its probe tool has been removed
    Given nginx is serving the default site on port 80 inside the container
    When the container runtime runs the built-in healthcheck
    Then the probe is a request to http://localhost/ every 30 seconds with a 3 second timeout
    And the probe cannot run because curl is not present in the finished image
    And the container is reported as unhealthy

  @id:nginx.operations-observability.health-and-lifecycle.009 @rule:images.lifecycle.exposed-http-https-ports @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#EXPOSE
  Scenario: The image declares HTTP and HTTPS ports
    When the operator inspects the image
    Then port 80 is declared as exposed
    And port 443 is declared as exposed

  @id:nginx.operations-observability.health-and-lifecycle.010 @rule:images.lifecycle.foreground-nginx-under-init @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#ENTRYPOINT
  Scenario: By default the container runs nginx in the foreground under a minimal init
    When the operator starts the container without a command
    Then dumb-init runs as the container's entrypoint
    And nginx runs in the foreground with "daemon off;"
    And the container keeps running while nginx is running

  @id:nginx.operations-observability.health-and-lifecycle.011 @rule:images.lifecycle.stop-signal-sigterm @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container sends nginx SIGTERM, which shuts it down fast rather than gracefully
    Given nginx is serving requests
    When the operator stops the container
    Then the container receives SIGTERM
    And nginx stops at once instead of finishing in-flight requests
