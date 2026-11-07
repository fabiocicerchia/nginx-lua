@domain:operations-observability @area:health-and-lifecycle @from:1-19-3/debian
Feature: Container runtime defaults
  Operators running the 1.19.3 Debian images rely on fixed ports, health reporting, graceful shutdown, log forwarding and a stable nginx user id for volumes and orchestration.

  Background:
    Given an nginx-lua 1.19.3 container built from a debian image

  @id:nginx.operations-observability.health-and-lifecycle.122 @rule:container.lifecycle.health-ports-and-graceful-stop @inferred @source:nginx/1.19.3/debian/10.6/Dockerfile#HEALTHCHECK
  Scenario: The container reports health from the local site and stops gracefully
    Given nginx is serving on port 80 inside the container
    When the container runtime checks the container's health
    Then the container is healthy while http://localhost/ answers with a success status
    And the container is unhealthy if http://localhost/ doesn't answer within 3 seconds
    And ports 80 and 443 are declared as exposed
    And stopping the container sends SIGQUIT so nginx finishes in-flight requests

  @id:nginx.operations-observability.health-and-lifecycle.123 @rule:container.logging.access-stdout-error-stderr @inferred @source:nginx/1.19.3/debian/10.6/Dockerfile#RUN
  Scenario: Access and error logs go to the container's output streams
    Given nginx uses its default log paths
    When a client requests http://localhost/
    Then the access log line appears on the container's stdout
    And nginx error messages appear on the container's stderr

  @id:nginx.operations-observability.health-and-lifecycle.124 @rule:container.default-config.nginx-user-id @inferred @source:nginx/1.19.3/debian/10.6/Dockerfile#RUN @questionable
  Scenario Outline: nginx worker processes run as the unprivileged nginx user with a fixed id
    Given the container is built from <variant>
    When the operator inspects the nginx user inside the container
    Then the user "nginx" and group "nginx" have id <uid>
    And the user has no login shell and no home directory

    Examples:
      | variant          | uid   |
      | debian 10.6      | 101   |
      | debian 10.6-slim | 101   |
      | debian 10.5-slim | 101   |
      | debian 10.4-slim | 32548 |
