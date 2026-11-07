@domain:operations-observability @area:logging @from:1-19-3/fedora
Feature: Logs to the container output
  Lets operators collect nginx access and error logs through the container runtime instead of from files inside the container.

  Background:
    Given a container from the nginx-lua 1.19.3 Fedora image running the default command

  @id:nginx.operations-observability.logging.011 @rule:container.logging.stdout-stderr @inferred @source:nginx/1.19.3/fedora/33/Dockerfile#RUN
  Scenario: Access logs go to standard output and error logs to standard error
    Given the default log paths /var/log/nginx/access.log and /var/log/nginx/error.log are in use
    When a client requests http://localhost/missing
    Then the access log line for "GET /missing" appears on the container's standard output
    And the "No such file or directory" error line appears on the container's standard error
