@domain:operations-observability @area:logging @from:1-19-4/amazonlinux
Feature: Forwarding nginx logs to the container log
  Operators collect nginx access and error logs through the container runtime instead of from files.

  Background:
    Given the operator runs the nginx-lua Amazon Linux 2 image for nginx 1.19.4 with its default command

  @id:nginx.operations-observability.logging.014 @rule:logging.access-and-error-to-container-streams @inferred @source:nginx/1.19.4/amazonlinux/2.0.20200722.0/Dockerfile#RUN
  Scenario: Access logs go to standard output and error logs to standard error
    Given a client requests "http://localhost/missing"
    When the operator reads the container logs
    Then the access entry for "/missing" appears on the container's standard output
    And the "No such file or directory" error for "/missing" appears on the container's standard error
