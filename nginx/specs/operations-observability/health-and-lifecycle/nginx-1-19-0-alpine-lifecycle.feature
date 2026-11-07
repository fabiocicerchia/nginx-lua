@domain:operations-observability @area:health-and-lifecycle @from:1-19-0/alpine
Feature: Running and stopping the nginx 1.19.0 Alpine container
  Operators running the nginx 1.19.0 Alpine images rely on a known health probe, published ports and stop behaviour to orchestrate them safely.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.19.0 Alpine image with its default configuration

  @id:nginx.operations-observability.health-and-lifecycle.038 @rule:image.lifecycle.healthcheck-probes-local-root @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when nginx stops answering on its local root URL
    Given the container has been running for at least 30 seconds
    When the container runtime runs the built-in health probe
    Then the probe requests http://localhost/ with a 3 second timeout every 30 seconds
    And the container is healthy while that request returns a success status
    And the container is marked unhealthy when the request fails or returns an error status

  @id:nginx.operations-observability.health-and-lifecycle.039 @rule:image.lifecycle.exposed-ports @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#EXPOSE
  Scenario: The image publishes HTTP and HTTPS ports
    When the operator inspects the image
    Then ports 80 and 443 are listed as exposed

  @id:nginx.operations-observability.health-and-lifecycle.040 @rule:image.lifecycle.stop-signal @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#STOPSIGNAL @questionable
  Scenario Outline: Stopping the container sends nginx the variant's stop signal
    Given the container runs the <alpine> variant
    And a client request is in flight
    When the operator stops the container
    Then nginx receives <signal>
    And in-flight requests are <in_flight>

    Examples:
      | alpine | signal  | in_flight                             |
      | 3.12.0 | SIGQUIT | allowed to finish (graceful shutdown) |
      | 3.11.6 | SIGQUIT | allowed to finish (graceful shutdown) |
      | 3.11.5 | SIGTERM | cut off (fast shutdown)               |
      | 3.10.5 | SIGTERM | cut off (fast shutdown)               |
