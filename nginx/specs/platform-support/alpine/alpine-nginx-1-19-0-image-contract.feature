@domain:platform-support @area:alpine @from:1-19-0/alpine
Feature: Running nginx 1.19.0 with Lua on Alpine
  Operators who deploy the nginx 1.19.0 Alpine images get a container that serves web traffic, logs to the Docker collector and reports its own health.

  Background:
    Given the operator has pulled an nginx-lua 1.19.0 Alpine image

  @id:nginx.platform-support.alpine.008 @rule:image-runtime.ports.http-and-https-exposed @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#EXPOSE
  Scenario Outline: The image advertises HTTP and HTTPS ports
    Given the operator has pulled the nginx 1.19.0 image on Alpine <alpine_release>
    When the operator inspects the image
    Then port 80 is listed as exposed
    And port 443 is listed as exposed

    Examples:
      | alpine_release |
      | 3.10.5         |
      | 3.11.5         |
      | 3.11.6         |
      | 3.12.0         |

  @id:nginx.platform-support.alpine.009 @rule:image-runtime.process.nginx-foreground-under-init @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#CMD
  Scenario: The container runs nginx in the foreground as its main process
    Given the operator has pulled the nginx 1.19.0 image on Alpine 3.12.0
    When the operator starts the container with no command
    Then nginx runs in the foreground without daemonising
    And the container stays up serving on port 80
    And a process supervisor (dumb-init) is the container's first process

  @id:nginx.platform-support.alpine.010 @rule:image-runtime.logs.forwarded-to-container-output @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's log output
    Given the operator has pulled the nginx 1.19.0 image on Alpine 3.12.0
    And the container is running
    When a client requests a page
    Then the access log line appears in the container's standard output
    And errors appear in the container's standard error

  @id:nginx.platform-support.alpine.011 @rule:image-runtime.health.unhealthy-when-root-page-fails @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the root page stops answering
    Given the operator has pulled the nginx 1.19.0 image on Alpine 3.12.0
    And the container is running
    When the orchestrator runs the health check and http://localhost/ returns an error status
    Then the check fails
    And after repeated failures every 30 seconds the container is marked unhealthy

  @id:nginx.platform-support.alpine.012 @rule:image-runtime.shutdown.stop-signal-per-release @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#STOPSIGNAL @questionable
  Scenario Outline: Stopping the container sends the image's declared stop signal
    Given a container from the nginx 1.19.0 image on Alpine <alpine_release> is running
    When the operator stops the container
    Then the container receives <signal> as its stop signal

    Examples:
      | alpine_release | signal  |
      | 3.10.5         | SIGTERM |
      | 3.11.5         | SIGTERM |
      | 3.11.6         | SIGQUIT |
      | 3.12.0         | SIGQUIT |
