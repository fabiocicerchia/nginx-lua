@domain:operations-observability @area:logging @from:1-19-3/ubuntu
Feature: Container logs
  Lets operators read nginx access and error logs with the container runtime's log tooling.

  @id:nginx.operations-observability.logging.012 @rule:container.logging.access-stdout-errors-stderr @inferred @source:nginx/1.19.3/ubuntu/20.04/Dockerfile#RUN
  Scenario: Access logs go to standard output and error logs to standard error
    Given a container from the nginx 1.19.3 Ubuntu 20.04 image runs with the default log paths
    When a client requests http://localhost/missing
    Then the access log line appears on the container's standard output
    And the "No such file or directory" error line appears on the container's standard error
