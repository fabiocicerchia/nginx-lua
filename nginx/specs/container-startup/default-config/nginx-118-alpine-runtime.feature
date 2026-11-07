@domain:container-startup @area:default-config @from:1-18-0/alpine
Feature: Running the nginx 1.18 Alpine container
  Operators who start the nginx 1.18 Alpine image get a working web server with sane process, logging, health and shutdown behaviour without writing any configuration.

  Background:
    Given Given the operator uses an nginx-lua 1.18.0 Alpine image (alpine 3.10.5, 3.11.5, 3.11.6 or 3.12.0)

  @id:nginx.container-startup.default-config.010 @rule:container.default-run.serves-welcome-page @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#CMD
  Scenario: A container started with no arguments serves the stock nginx welcome page on port 80
    Given the operator has not mounted any nginx configuration
    When the operator starts the container with port 80 published
    Then nginx runs in the foreground as the container's main process under dumb-init
    And a request to http://localhost/ returns 200 with the "Welcome to nginx!" page
    And the image declares ports 80 and 443

  @id:nginx.container-startup.default-config.011 @rule:container.security.workers-run-as-nginx-user @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#RUN
  Scenario: Worker processes run as the unprivileged nginx user
    Given the container is running with the default configuration
    When the operator lists the container's processes
    Then the nginx worker processes run as user nginx with uid 32548 and group nginx with gid 32548
    And the nginx user has no login shell

  @id:nginx.container-startup.default-config.012 @rule:observability.logging.logs-to-stdout-stderr @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's output streams
    Given the container is running with the default configuration
    When a client requests http://localhost/missing-page
    Then an access log line for GET /missing-page with status 404 appears on the container's stdout
    And the matching "No such file or directory" error line appears on the container's stderr

  @id:nginx.container-startup.default-config.013 @rule:observability.health.http-root-healthcheck @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when the site root stops answering
    Given the container is running
    When the container runtime runs the built-in healthcheck every 30 seconds
    Then the container is healthy while http://localhost/ answers with a non-error status within 3 seconds
    And the container is marked unhealthy when http://localhost/ returns an error status or does not answer within 3 seconds

  @id:nginx.container-startup.default-config.014 @rule:container.lifecycle.stop-is-fast-shutdown @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container shuts nginx down immediately
    Given the container is serving a long-running request
    When the operator stops the container
    Then nginx receives SIGTERM through dumb-init
    And nginx exits without waiting for the in-flight request to complete

  @id:nginx.container-startup.default-config.015 @rule:container.timezone.tz-variable-sets-local-time @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#RUN
  Scenario: Setting TZ changes the local time nginx writes
    Given the operator sets the environment variable TZ to Europe/Rome
    When a client requests http://localhost/
    Then the access log line timestamp is in Europe/Rome local time with its UTC offset
