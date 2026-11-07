@domain:operations-observability @area:logging @from:1-19-10/ubuntu
Feature: Container logging
  Sends nginx's access and error logs to the container's output streams so standard log collectors pick them up.

  @id:nginx.operations-observability.logging.008 @rule:operations.logging.logs-to-container-streams @inferred @source:nginx/1.19.10/ubuntu/20.04/Dockerfile#RUN
  Scenario: nginx access and error logs appear on the container's output streams
    Given the container runs with the shipped nginx configuration
    When a client sends a request to the container
    Then the access-log line, in the combined format with X-Forwarded-For, appears on the container's stdout
    And warnings and errors appear on the container's stderr
    And no log file grows inside the container
