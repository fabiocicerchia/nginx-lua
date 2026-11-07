@domain:operations-observability @area:health-and-lifecycle @from:1-17-10/fedora
Feature: Operating the Fedora nginx 1.17.10 container
  Lets operators run, monitor and stop the Fedora nginx container with standard Docker tooling.

  Background:
    Given a container running from fabiocicerchia/nginx-lua:1.17.10-fedora33 with the default command

  @id:nginx.operations-observability.health-and-lifecycle.012 @rule:operations.fedora-1-17-10.healthcheck-on-root @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is reported healthy only while nginx answers on the root URL
    Given nginx is <state>
    When Docker runs the built-in health check
    Then the container health becomes <health>

    Examples:
      | state                                                | health    |
      | answering http://localhost/ with a 2xx or 3xx status | healthy   |
      | returning a 4xx or 5xx status on http://localhost/   | unhealthy |
      | not answering within 3 seconds                       | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.013 @rule:operations.fedora-1-17-10.logs-to-container-output @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#RUN
  Scenario: Access and error logs show up in the container's output
    Given a client has made a request
    When the operator reads the container logs
    Then the access log line for that request appears on stdout
    And nginx error messages appear on stderr

  @id:nginx.operations-observability.health-and-lifecycle.014 @rule:operations.fedora-1-17-10.ports-and-foreground-run @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#CMD
  Scenario: By default the container runs nginx in the foreground and exposes ports 80 and 443
    Given no command override
    When the operator starts the container
    Then nginx runs in the foreground under dumb-init
    And ports 80 and 443 are listed as exposed

  @id:nginx.operations-observability.health-and-lifecycle.015 @rule:operations.fedora-1-17-10.stop-is-immediate @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container shuts nginx down fast instead of gracefully
    Given a client request is in progress
    When the operator stops the container
    Then nginx receives SIGTERM and exits without waiting for in-progress requests to finish
