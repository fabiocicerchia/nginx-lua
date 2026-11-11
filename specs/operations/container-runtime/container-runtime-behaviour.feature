@domain:operations @area:container-runtime @from:nginx-lua/dockerfile
Feature: Running the nginx-lua container
  Operators who run the nginx-lua image need it to serve web traffic, report its health, stop cleanly and log to the container log collector.

  Background:
    Given The nginx-lua image has been built and started with its default command

  @id:operations.container-runtime.002 @rule:runtime.container.healthcheck-on-root @inferred @source:Dockerfile#HEALTHCHECK @questionable
  Scenario: A container whose root page does not answer is reported unhealthy
    Given a running nginx-lua container whose root URL stops returning a success status
    When the container runtime runs its health check
    Then the check requests http://localhost/ every 30 seconds with a 3 second timeout
    And a non-success response or timeout marks the container unhealthy

  @id:operations.container-runtime.003 @rule:runtime.container.graceful-stop @inferred @source:Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets in-flight requests finish
    Given a running nginx-lua container serving requests
    When the operator stops the container
    Then the container receives SIGQUIT, which nginx treats as a graceful shutdown
