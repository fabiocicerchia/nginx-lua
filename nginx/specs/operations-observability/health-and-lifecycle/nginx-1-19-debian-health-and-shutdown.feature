@domain:operations-observability @area:health-and-lifecycle @from:1-19-0/debian
Feature: Monitoring and stopping nginx 1.19.0 Debian containers
  Operators running the nginx 1.19.0 Debian images rely on the built-in health status and on the stop signal to know when a container is serving and to shut it down without dropping requests.

  Background:
    Given an operator runs a container from an nginx 1.19.0 Debian slim image

  @id:nginx.operations-observability.health-and-lifecycle.051 @rule:lifecycle.healthcheck.unhealthy-when-root-not-served @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when nginx stops answering on its home page
    Given the image is the Debian 10.3-slim or 10.4-slim variant
    And nginx no longer answers http://localhost/ with a success status
    When the container runtime runs the built-in health probe
    Then the probe fails
    And after repeated failures the container status shows unhealthy
    And the probe runs every 30 seconds and gives up on a single attempt after 3 seconds

  @id:nginx.operations-observability.health-and-lifecycle.052 @rule:lifecycle.healthcheck.legacy-probe-tool-missing @inferred @source:nginx/1.19.0/debian/8.11-slim/Dockerfile#HEALTHCHECK @questionable
  Scenario Outline: Older Debian 1.19.0 images never report healthy because the probe tool is removed
    Given the image is the Debian <variant> variant
    And nginx is answering http://localhost/ with 200
    When the container runtime runs the built-in health probe
    Then the probe command curl cannot be found
    And the container status turns unhealthy even though nginx is serving

    Examples:
      | variant   |
      | 8.11-slim |
      | 9.12-slim |
      | 10.2-slim |

  @id:nginx.operations-observability.health-and-lifecycle.053 @rule:lifecycle.shutdown.stop-signal-per-variant @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#STOPSIGNAL @questionable
  Scenario Outline: Stopping the container sends nginx the variant's stop signal
    Given the image is the Debian <variant> variant
    And nginx is serving requests
    When the operator stops the container
    Then nginx receives <signal>
    And nginx <shutdown>

    Examples:
      | variant   | signal  | shutdown                                       |
      | 10.4-slim | SIGQUIT | finishes in-flight requests before exiting     |
      | 10.3-slim | SIGQUIT | finishes in-flight requests before exiting     |
      | 10.2-slim | SIGTERM | exits immediately, dropping in-flight requests |
      | 9.12-slim | SIGTERM | exits immediately, dropping in-flight requests |
      | 8.11-slim | SIGTERM | exits immediately, dropping in-flight requests |
