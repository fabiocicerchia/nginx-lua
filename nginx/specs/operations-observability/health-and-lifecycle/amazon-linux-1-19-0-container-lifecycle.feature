@domain:operations-observability @area:health-and-lifecycle @from:1-19-0/amazonlinux
Feature: Running the nginx 1.19.0 Amazon Linux container
  Operators running the nginx 1.19.0 Amazon Linux images rely on the container's health status, ports, stop behaviour and log stream to run it under Docker or an orchestrator.

  Background:
    Given Given an nginx 1.19.0 Amazon Linux image of fabiocicerchia/nginx-lua

  @id:nginx.operations-observability.health-and-lifecycle.041 @rule:operations.container.healthcheck-probes-root-url @inferred @source:nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when the site root stops answering
    Given the container is running with its built-in healthcheck
    When the container runtime probes the container
    Then the probe requests http://localhost/ every 30 seconds
    And a probe that gets no successful response within 3 seconds counts as failed
    And the container is marked unhealthy after repeated failed probes

  @id:nginx.operations-observability.health-and-lifecycle.042 @rule:operations.container.exposes-http-and-https-ports @inferred @source:nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile#EXPOSE
  Scenario: The image advertises the HTTP and HTTPS ports
    When the operator inspects the image
    Then ports 80 and 443 are listed as exposed

  @id:nginx.operations-observability.health-and-lifecycle.043 @rule:operations.container.stop-signal-per-variant @inferred @source:nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile#STOPSIGNAL @questionable
  Scenario Outline: Stopping the container shuts nginx down gracefully only on the 2020 Amazon Linux 2 bases
    Given the container runs the <variant> image
    And a client request is in progress
    When the operator stops the container
    Then nginx receives <signal>
    And in-flight requests are <in_flight>

    Examples:
      | variant                                | signal  | in_flight                            |
      | 1.19.0-amazonlinux2.0.20200304.0       | SIGQUIT | allowed to finish before nginx exits |
      | 1.19.0-amazonlinux2.0.20200406.0       | SIGQUIT | allowed to finish before nginx exits |
      | 1.19.0-amazonlinux2.0.20180622.1       | SIGTERM | cut off by a fast shutdown           |
      | 1.19.0-amazonlinux2.0.20180827         | SIGTERM | cut off by a fast shutdown           |
      | 1.19.0-amazonlinux2.0.20181010         | SIGTERM | cut off by a fast shutdown           |
      | 1.19.0-amazonlinux2018.03.0.20200318.1 | SIGTERM | cut off by a fast shutdown           |

  @id:nginx.operations-observability.health-and-lifecycle.044 @rule:operations.logging.logs-to-stdout-stderr @inferred @source:nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile#RUN
  Scenario: Access and error logs appear in the container log stream
    Given the container is running with the default log paths
    When a client requests a page
    Then the access log entry appears on the container's standard output
    And nginx error messages appear on the container's standard error

  @id:nginx.operations-observability.health-and-lifecycle.045 @rule:operations.container.nginx-runs-in-foreground-as-nginx-user @inferred @source:nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile#ENTRYPOINT
  Scenario: The container runs nginx in the foreground with workers as the nginx user
    When the operator starts the container without a command
    Then dumb-init runs as the container's main process
    And nginx runs in the foreground with 'daemon off;'
    And nginx worker processes run as user nginx with uid 32548 and gid 32548
