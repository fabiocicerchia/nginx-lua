@domain:operations-observability @area:logging @from:1-19-10/amazonlinux
Feature: Forwarding nginx logs to the container log
  Lets operators read nginx access and error logs with their usual container log tooling, without opening files inside the container.

  Background:
    Given the operator runs the nginx-lua 1.19.10 Amazon Linux 2 image with the shipped log paths

  @id:nginx.operations-observability.logging.006 @rule:operations.logging.forwarded-to-stdout-stderr @inferred @source:nginx/1.19.10/amazonlinux/2.0.20210326.0/Dockerfile#RUN
  Scenario: Access logs go to the container's standard output and error logs to its standard error
    Given a client has requested http://www.example.com/
    When the operator views the container logs
    Then the access log line for the request appears on standard output
    And nginx error messages appear on standard error
