@domain:operations-observability @area:logging @from:1-19-2/ubuntu
Feature: Reading nginx logs from the container
  Operators collect nginx access and error logs through `docker logs` and log drivers instead of reading files inside the container.

  Background:
    Given Given a container started from the nginx-lua 1.19.2 Ubuntu image with the default log paths

  @id:nginx.operations-observability.logging.010 @rule:logging.nginx-logs-to-container-streams @inferred @source:nginx/1.19.2/ubuntu/20.04/Dockerfile#RUN
  Scenario Outline: nginx access and error logs go to the container's output streams
    Given nginx writes a line to its <log>
    When the operator reads the container logs
    Then the line appears on the container's <stream>

    Examples:
      | log                                  | stream |
      | access log /var/log/nginx/access.log | stdout |
      | error log /var/log/nginx/error.log   | stderr |
