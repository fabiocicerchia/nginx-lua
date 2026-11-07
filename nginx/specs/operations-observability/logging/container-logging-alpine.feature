@domain:operations-observability @area:logging @from:1-19-4/alpine
Feature: Forwarding nginx logs to the container log
  Lets operators read nginx access and error logs through docker logs without mounting files.

  Background:
    Given the nginx-lua 1.19.4 Alpine 3.12.1 image running with the default configuration

  @id:nginx.operations-observability.logging.013 @rule:observability.logging.access-stdout-error-stderr @inferred @source:nginx/1.19.4/alpine/3.12.1/Dockerfile#RUN
  Scenario: Access logs go to standard output and error logs to standard error
    Given the container is serving traffic
    When a client requests "/missing.html"
    Then the access entry for "/missing.html" appears on the container's stdout
    And the "open() ... failed" error for it appears on the container's stderr
