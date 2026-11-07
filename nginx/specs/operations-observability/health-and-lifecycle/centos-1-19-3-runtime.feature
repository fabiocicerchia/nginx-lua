@domain:operations-observability @area:health-and-lifecycle @from:1-19-3/centos
Feature: Running the nginx 1.19.3 CentOS 8 container
  Operators running the nginx 1.19.3 CentOS 8 images get a container that reports its own health, stops gracefully, sends its logs to the container log stream and runs workers without privileges.

  Background:
    Given the operator runs an nginx 1.19.3 CentOS 8 image (centos 8, 8.2.2004 or 8.1.1911) with its default command

  @id:nginx.operations-observability.health-and-lifecycle.118 @rule:container.health.healthcheck-probes-default-site @inferred @source:nginx/1.19.3/centos/8/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the local site stops answering
    Given nginx inside the container stops returning a success response for http://localhost/
    When the container runtime runs the built-in health check
    Then the check fails after at most 3 seconds
    And the container is reported as unhealthy
    And the check repeats every 30 seconds

  @id:nginx.operations-observability.health-and-lifecycle.119 @rule:container.lifecycle.sigquit-graceful-stop @inferred @source:nginx/1.19.3/centos/8/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets nginx finish in-flight requests
    Given nginx is serving requests on ports 80 and 443
    When the operator stops the container
    Then nginx receives SIGQUIT rather than SIGTERM
    And nginx performs a graceful shutdown before the container exits

  @id:nginx.operations-observability.health-and-lifecycle.120 @rule:container.logging.logs-to-stdout-stderr @inferred @source:nginx/1.19.3/centos/8/Dockerfile#RUN
  Scenario: Access logs go to standard output and error logs to standard error
    Given nginx uses the default access and error log locations
    When a client sends a request to the container
    Then the access log line appears on the container's standard output
    And error messages appear on the container's standard error
    And no log file grows inside the container

  @id:nginx.operations-observability.health-and-lifecycle.121 @rule:container.security.workers-run-as-unprivileged-nginx-user @inferred @source:nginx/1.19.3/centos/8/Dockerfile#RUN
  Scenario: nginx workers run as an unprivileged account with no login shell
    Given the configuration does not override the worker user
    When the operator starts the container
    Then worker processes run as user nginx with uid 101 and group nginx with gid 101
    And the nginx account has no login shell and no home directory
