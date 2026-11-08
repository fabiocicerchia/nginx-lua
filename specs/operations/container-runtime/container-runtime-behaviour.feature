@domain:operations @area:container-runtime @from:nginx-lua/dockerfile
Feature: Running the nginx-lua container
  Operators who run the nginx-lua image need it to serve web traffic, report its health, stop cleanly and log to the container log collector.

  Background:
    Given The nginx-lua image has been built and started with its default command

  @id:operations.container-runtime.001 @rule:runtime.container.serves-http-and-https-ports @inferred @source:Dockerfile#EXPOSE
  Scenario: The container serves web traffic on ports 80 and 443
    Given an operator has started the nginx-lua image with ports 80 and 443 published
    When the operator inspects the image's declared ports
    Then ports 80 and 443 are declared as exposed

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
