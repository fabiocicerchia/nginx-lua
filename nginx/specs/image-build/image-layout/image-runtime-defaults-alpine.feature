@domain:image-build @area:image-layout @from:1-23-0/alpine
Feature: Container defaults visible to operators
  Describes what an operator sees from the running image: log streams, health status and exposed ports.

  Background:
    Given Given the nginx-lua 1.23.0 Alpine image

  @id:nginx.image-build.image-layout.020 @rule:image-build.image-layout.health-status-from-http-probe @inferred @source:nginx/1.23.0/alpine/3.16.0/Dockerfile#HEALTHCHECK
  Scenario: The container reports healthy only while the default site answers
    Given the container is running
    When the orchestrator evaluates container health every 30 seconds
    Then it is healthy when http://localhost/ returns a successful status
    And it is unhealthy when the request fails or takes over 3 seconds
