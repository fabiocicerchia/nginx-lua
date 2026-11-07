@domain:operations-observability @area:health-and-lifecycle @from:1-19-3/alpine
Feature: Container health, ports, shutdown and logs
  Gives operators and orchestrators a health signal, the standard web ports, graceful shutdown and logs on the container's output streams.

  Background:
    Given a container from any nginx 1.19.3 Alpine image is running with the default command

  @id:nginx.operations-observability.health-and-lifecycle.113 @rule:container.lifecycle.ports-80-443 @inferred @source:nginx/1.19.3/alpine/3.12.1/Dockerfile#EXPOSE
  Scenario: The image declares ports 80 and 443 for publishing
    When the operator inspects the image
    Then the exposed ports are 80/tcp and 443/tcp
