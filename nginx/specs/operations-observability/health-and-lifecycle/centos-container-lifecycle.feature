@domain:operations-observability @area:health-and-lifecycle @from:1-18-0/centos
Feature: Container health and shutdown
  Lets operators and orchestrators tell whether an nginx-lua CentOS container is serving and stop it predictably.

  Background:
    Given the operator runs an nginx-lua 1.18.0 CentOS image with its default configuration

  @id:nginx.operations-observability.health-and-lifecycle.027 @rule:ops.health.healthcheck-probes-local-http @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#HEALTHCHECK
  Scenario: The container is healthy only while the local web root answers
    Given the container has been running for at least 30 seconds
    When the container runtime runs the built-in healthcheck
    Then it requests http://localhost/ with a 3 second timeout every 30 seconds
    And the container is reported healthy when the response is a success status
    And the container is reported unhealthy when the request fails, times out or returns an error status

  @id:nginx.operations-observability.health-and-lifecycle.028 @rule:ops.lifecycle.stop-signal @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container sends nginx a fast-shutdown signal
    Given nginx is serving a long-running request for a client
    When the operator stops the container
    Then nginx receives SIGTERM through dumb-init
    And nginx shuts down at once without waiting for the in-flight request to finish
