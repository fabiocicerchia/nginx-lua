@domain:operations-observability @area:health-and-lifecycle @from:1-19-1/debian
Feature: Running the nginx-lua container
  Operators rely on the image to start nginx in the foreground, report its health to the orchestrator and shut down without dropping in-flight requests.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.19.1 Debian slim image with its default configuration

  @id:nginx.operations-observability.health-and-lifecycle.062 @rule:operations.lifecycle.http-healthcheck @inferred @source:nginx/1.19.1/debian/10.5-slim/Dockerfile#HEALTHCHECK
  Scenario: The container reports healthy only while nginx answers on localhost
    Given the container has been running for at least 30 seconds
    When the container runtime runs the image's health probe
    Then the probe requests http://localhost/ inside the container
    And the container is marked healthy when the response status is below 400
    And the container is marked unhealthy when there is no answer within 3 seconds or the status is 400 or above

  @id:nginx.operations-observability.health-and-lifecycle.063 @rule:operations.lifecycle.graceful-stop @inferred @source:nginx/1.19.1/debian/10.5-slim/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container shuts nginx down gracefully
    Given nginx is serving a long-running request
    When the operator stops the container
    Then nginx receives SIGQUIT through the container's init process
    And the in-flight request is completed before nginx exits

  @id:nginx.operations-observability.health-and-lifecycle.064 @rule:operations.lifecycle.default-run-and-ports @inferred @source:nginx/1.19.1/debian/10.5-slim/Dockerfile#CMD
  Scenario: Started without arguments, the container serves HTTP and HTTPS ports with nginx in the foreground
    When the operator starts the container without a command
    Then nginx runs in the foreground as the container's main process
    And ports 80 and 443 are declared as exposed

  @id:nginx.operations-observability.health-and-lifecycle.065 @rule:operations.logging.stdout-stderr @inferred @source:nginx/1.19.1/debian/10.5-slim/Dockerfile#RUN
  Scenario: nginx access and error logs appear in the container's log stream
    When a client requests a page that does not exist
    Then the access log line appears on the container's standard output
    And the error log line appears on the container's standard error

  @id:nginx.operations-observability.health-and-lifecycle.066 @rule:container.default-config.nginx-user-uid @inferred @source:nginx/1.19.1/debian/10.5-slim/Dockerfile#RUN
  Scenario: nginx workers run as the unprivileged nginx user with a fixed id
    When the operator starts the container
    Then nginx worker processes run as user nginx and group nginx
    And the nginx user and group both have id 32548
    And the nginx user cannot log in
