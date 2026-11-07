@domain:operations-observability @area:logging @from:1-17-10/centos
Feature: Container logging
  Lets operators read nginx access and error logs through the container runtime instead of files inside the container.

  Background:
    Given the operator runs a CentOS nginx 1.17.10 container with the default log paths

  @id:nginx.operations-observability.logging.001 @rule:logging.default-paths.forwarded-to-container-streams @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#RUN
  Scenario Outline: Access logs go to stdout and error logs go to stderr
    Given nginx writes to its <log> at <path>
    When the operator reads the container logs
    Then the entries appear on the container's <stream>

    Examples:
      | log        | path                      | stream |
      | access log | /var/log/nginx/access.log | stdout |
      | error log  | /var/log/nginx/error.log  | stderr |
