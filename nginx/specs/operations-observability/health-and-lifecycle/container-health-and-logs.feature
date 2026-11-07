@domain:operations-observability @area:health-and-lifecycle @from:1-19-10/debian
Feature: Container health, logs and shutdown
  Lets operators and orchestrators monitor, collect logs from and stop the container with standard Docker tooling.

  Background:
    Given the container runs with the default configuration

  @id:nginx.operations-observability.health-and-lifecycle.081 @rule:ops.lifecycle.healthcheck-probes-default-site @inferred @source:nginx/1.19.10/debian/10.9/Dockerfile#HEALTHCHECK @questionable
  Scenario: The built-in health check reports unhealthy when the default site does not answer with success
    Given the default site answers http://localhost/ with status 404
    When the container runtime runs the health check
    Then it requests http://localhost/ every 30 seconds with a 3 second timeout
    And the container is reported "unhealthy"

  @id:nginx.operations-observability.health-and-lifecycle.082 @rule:ops.lifecycle.graceful-stop @inferred @source:nginx/1.19.10/debian/10.9/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container shuts nginx down gracefully
    When the operator stops the container
    Then nginx receives SIGQUIT
    And in-flight requests are allowed to finish before nginx exits

  @id:nginx.operations-observability.health-and-lifecycle.083 @rule:ops.lifecycle.exposed-ports @inferred @source:nginx/1.19.10/debian/10.9/Dockerfile#EXPOSE
  Scenario: The image declares HTTP and HTTPS ports
    When the operator inspects the image
    Then ports 80 and 443 are listed as exposed

  @id:nginx.operations-observability.health-and-lifecycle.084 @rule:ops.logging.logs-to-container-output @inferred @source:nginx/1.19.10/debian/10.9/Dockerfile#RUN
  Scenario: Access logs go to the container's stdout and error logs to its stderr
    When a client requests http://localhost/ from the running container
    Then an access log line in the "main" format appears on the container's stdout
    And nginx errors at level warn and above appear on the container's stderr
