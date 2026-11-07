@domain:operations-observability @area:logging @from:1-19-0/debian
Feature: Collecting nginx 1.19.0 Debian container logs
  Operators read nginx access and error logs through the container runtime's log collection, with no files to manage inside the container.

  @id:nginx.operations-observability.logging.004 @rule:logging.forwarding.access-stdout-error-stderr @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#ln -sf
  Scenario: Access logs go to standard output and error logs to standard error
    Given a container from an nginx 1.19.0 Debian slim image is serving traffic with the default log paths
    When a client requests a page
    Then the access log entry shows on the container's standard output
    And nginx errors show on the container's standard error
    And no log file builds up inside the container
