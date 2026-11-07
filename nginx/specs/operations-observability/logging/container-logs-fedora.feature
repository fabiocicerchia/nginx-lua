@domain:operations-observability @area:logging @from:1-19-10/fedora
Feature: Container logs
  Lets operators read nginx access and error logs with the container runtime's log tooling.

  @id:nginx.operations-observability.logging.007 @rule:container.logging.logs-to-standard-streams @inferred @source:nginx/1.19.10/fedora/33/Dockerfile#RUN
  Scenario Outline: nginx logs go to the container's output streams
    Given the container runs with the shipped configuration
    When nginx writes to its <log> log
    Then the entry appears on the container's <stream>

    Examples:
      | log    | stream |
      | access | stdout |
      | error  | stderr |
