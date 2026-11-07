@domain:operations-observability @area:health-and-lifecycle @from:1-19-0/ubuntu
Feature: Operating nginx 1.19.0 Ubuntu containers
  Lets operators rely on health status, shutdown, logging and the process user of the 1.19.0 Ubuntu containers when they run them in production.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.19.0 Ubuntu container with the default command

  @id:nginx.operations-observability.health-and-lifecycle.054 @rule:operations.lifecycle.ubuntu-1-19-0-healthcheck @inferred @source:nginx/1.19.0/ubuntu/18.04/Dockerfile#HEALTHCHECK @questionable
  Scenario Outline: The built-in health check reflects whether nginx answers on port 80
    Given the image is built for Ubuntu <release>
    And nginx is serving the default site on port 80
    When the container runtime runs the built-in health check
    Then after the check runs, the container reports <status>

    Examples:
      | release | status    |
      | 20.04   | healthy   |
      | 20.10   | healthy   |
      | 18.04   | unhealthy |
      | 19.10   | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.055 @rule:operations.lifecycle.ubuntu-1-19-0-stop-signal @inferred @source:nginx/1.19.0/ubuntu/20.04/Dockerfile#STOPSIGNAL @questionable
  Scenario Outline: Stopping the container shuts nginx down gracefully only on Ubuntu 20.x
    Given the image is built for Ubuntu <release>
    And a client request is in flight
    When the operator stops the container
    Then nginx receives <signal>
    And in-flight requests are <effect>

    Examples:
      | release | signal  | effect                   |
      | 20.04   | SIGQUIT | allowed to finish        |
      | 20.10   | SIGQUIT | allowed to finish        |
      | 18.04   | SIGTERM | cut off by fast shutdown |
      | 19.10   | SIGTERM | cut off by fast shutdown |

  @id:nginx.operations-observability.health-and-lifecycle.056 @rule:operations.logging.ubuntu-1-19-0-stdout-stderr @inferred @source:nginx/1.19.0/ubuntu/20.04/Dockerfile#RUN
  Scenario: Access logs go to the container's stdout and error logs to its stderr
    Given nginx logs to its default access and error log paths
    When a client requests a page
    Then the access log line appears on the container's stdout
    And nginx errors appear on the container's stderr

  @id:nginx.operations-observability.health-and-lifecycle.057 @rule:operations.lifecycle.ubuntu-1-19-0-default-run @inferred @source:nginx/1.19.0/ubuntu/20.04/Dockerfile#CMD
  Scenario: The container serves HTTP on port 80 in the foreground by default
    Given no command override is given
    When the operator starts the container publishing port 80
    Then nginx runs in the foreground under dumb-init
    And the default site answers on port 80
    And ports 80 and 443 are declared as exposed

  @id:nginx.operations-observability.health-and-lifecycle.058 @rule:operations.lifecycle.ubuntu-1-19-0-unprivileged-workers @inferred @source:nginx/1.19.0/ubuntu/20.04/Dockerfile#RUN
  Scenario: nginx worker processes run as the unprivileged nginx user
    Given the shipped configuration does not set a user directive
    When the operator starts the container
    Then worker processes run as user nginx with uid 32548 and gid 32548
    And the nginx user has no login shell
