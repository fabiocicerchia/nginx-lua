@domain:operations-observability @area:health-and-lifecycle @from:1-17-10/ubuntu
Feature: Running and operating the 1.17.10 Ubuntu container
  Covers what operators of the 1.17.10 Ubuntu containers rely on at runtime: served ports, log streams, worker identity, health status and shutdown.

  Background:
    Given a container is running the nginx 1.17.10 Ubuntu image with its default command

  @id:nginx.operations-observability.health-and-lifecycle.016 @rule:lifecycle.ubuntu-1-17-10.default-serves-http @inferred @source:nginx/1.17.10/ubuntu/20.04/Dockerfile#CMD
  Scenario: The container serves the default nginx page on port 80 out of the box
    Given no custom configuration is mounted
    When a client requests http://localhost/ from the published port 80
    Then the response status is 200
    And the body is the nginx welcome page
    And ports 80 and 443 are declared as exposed

  @id:nginx.operations-observability.health-and-lifecycle.017 @rule:lifecycle.ubuntu-1-17-10.healthcheck-reports-unhealthy @inferred @source:nginx/1.17.10/ubuntu/20.04/Dockerfile#HEALTHCHECK @questionable
  Scenario: The built-in health check reports the container unhealthy even while nginx serves traffic
    Given nginx is answering http://localhost/ with status 200
    When the container runtime runs the built-in health check
    Then the check fails because the curl command it needs is not in the image
    And after the retries the container status is "unhealthy"

  @id:nginx.operations-observability.health-and-lifecycle.018 @rule:logging.ubuntu-1-17-10.logs-to-container-streams @inferred @source:nginx/1.17.10/ubuntu/20.04/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's output
    Given the default log paths are in use
    When a client requests a page that does not exist
    Then an access log line for the request appears on the container's stdout
    And the related error log line appears on the container's stderr

  @id:nginx.operations-observability.health-and-lifecycle.019 @rule:security.ubuntu-1-17-10.workers-run-as-nginx-user @inferred @source:nginx/1.17.10/ubuntu/20.04/Dockerfile#RUN
  Scenario: Request-handling workers run as the unprivileged nginx user
    Given the configuration does not set a user directive
    When the operator lists the container's nginx processes
    Then the worker processes run as user nginx with uid 32548 and group nginx with gid 32548
    And the nginx user has no login shell and no home directory

  @id:nginx.operations-observability.health-and-lifecycle.020 @rule:lifecycle.ubuntu-1-17-10.stop-uses-fast-shutdown @inferred @source:nginx/1.17.10/ubuntu/20.04/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container makes nginx shut down fast, not gracefully
    Given a client request is still in flight
    When the operator stops the container
    Then nginx receives SIGTERM and exits without waiting for in-flight requests to finish

  @id:nginx.operations-observability.health-and-lifecycle.021 @rule:lifecycle.ubuntu-1-17-10.timezone-from-environment @inferred @source:nginx/1.17.10/ubuntu/20.04/Dockerfile#RUN
  Scenario: The container's time zone can be set through the TZ environment variable
    Given the container was started with TZ set to Europe/Rome
    When a client requests http://localhost/
    Then the access log timestamp uses the Europe/Rome offset
