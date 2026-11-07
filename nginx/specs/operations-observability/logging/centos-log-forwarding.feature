@domain:operations-observability @area:logging @from:1-18-0/centos
Feature: Forwarding nginx logs to the container output
  Lets operators collect nginx access and error logs with the container runtime's log tooling, without mounting log volumes.

  Background:
    Given the operator runs an nginx-lua 1.18.0 CentOS image with its default log paths

  @id:nginx.operations-observability.logging.002 @rule:ops.logging.logs-to-stdio @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#RUN
  Scenario Outline: Access and error logs show up in the container's output streams
    Given a client sends GET / to the container
    When nginx writes a <log> entry
    Then the entry appears on the container's <stream>
    And no log file grows inside the container

    Examples:
      | log        | stream |
      | access log | stdout |
      | error log  | stderr |
