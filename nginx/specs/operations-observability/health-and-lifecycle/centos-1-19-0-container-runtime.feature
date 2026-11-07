@domain:operations-observability @area:health-and-lifecycle @from:1-19-0/centos
Feature: Running an nginx 1.19.0 CentOS container
  Operators who run the CentOS-based nginx 1.19.0 images need predictable startup, health reporting, logging, identity and shutdown so the container behaves well under an orchestrator.

  Background:
    Given the operator runs an nginx-lua 1.19.0 image built on CentOS

  @id:nginx.operations-observability.health-and-lifecycle.046 @rule:images.lifecycle.healthcheck-on-local-http @inferred @source:nginx/1.19.0/centos/8.2.2004/Dockerfile#HEALTHCHECK
  Scenario: The container reports itself unhealthy when nginx stops answering on port 80
    Given the container is running with the shipped configuration
    When the container runtime probes the container's health
    Then the probe requests http://localhost/ every 30 seconds with a 3 second timeout
    And the container is healthy when the request returns a success status
    And the container is marked unhealthy when the request fails or returns an error status

  @id:nginx.operations-observability.health-and-lifecycle.047 @rule:images.lifecycle.stop-signal-per-variant @inferred @source:nginx/1.19.0/centos/8.2.2004/Dockerfile#STOPSIGNAL @questionable
  Scenario Outline: Stopping the container sends nginx the variant's stop signal
    Given the container is running the <variant> image
    And nginx is serving requests
    When the operator stops the container
    Then nginx receives <signal>
    And nginx performs a <shutdown> shutdown

    Examples:
      | variant               | signal  | shutdown                             |
      | 1.19.0-centos8.2.2004 | SIGQUIT | graceful (in-flight requests finish) |
      | 1.19.0-centos8.1.1911 | SIGQUIT | graceful (in-flight requests finish) |
      | 1.19.0-centos7.8.2003 | SIGTERM | fast (in-flight requests are cut)    |

  @id:nginx.operations-observability.health-and-lifecycle.049 @rule:images.startup.foreground-nginx-under-init @inferred @source:nginx/1.19.0/centos/8.2.2004/Dockerfile#CMD
  Scenario: A container started without arguments runs nginx in the foreground on ports 80 and 443
    Given no command is given to the container
    When the operator starts the container
    Then nginx runs in the foreground with daemon mode off
    And nginx runs under dumb-init as the container's init process
    And ports 80 and 443 are declared as exposed

  @id:nginx.operations-observability.health-and-lifecycle.050 @rule:images.identity.nginx-user-fixed-ids @inferred @source:nginx/1.19.0/centos/8.2.2004/Dockerfile#RUN
  Scenario: nginx worker processes run as the nginx user with ID 32548
    Given the operator mounts a volume that the workers must read
    When the operator starts the container
    Then the worker processes run as user nginx with uid 32548
    And the worker processes run with group nginx with gid 32548
    And the nginx user has no login shell and no home directory
