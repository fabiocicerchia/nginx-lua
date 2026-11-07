@domain:operations-observability @area:logging @from:1-19-0/alpine
Feature: Container logging for the nginx 1.19.0 Alpine image
  Operators collect nginx access and error logs through the container runtime instead of files inside the container.

  @id:nginx.operations-observability.logging.003 @rule:image.logging.access-stdout-error-stderr @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#RUN
  Scenario: Access logs go to standard output and error logs to standard error
    Given the container runs with the default log paths
    When a client requests http://localhost/missing-page
    Then the access log line appears on the container's stdout
    And the not-found error line appears on the container's stderr
    And no log file grows inside the container
