@domain:image-build @area:image-layout @from:1-19-4/alpine
Feature: Container image runtime layout
  Operators rely on the image logging to Docker, exposing web ports and reporting health.

  Background:
    Given Given the nginx-lua Alpine 3.12.1 image with nginx 1.19.4

  @id:nginx.image-build.image-layout.002 @rule:image-build.image-layout.logs-and-health @inferred @source:nginx/1.19.4/alpine/3.12.1/Dockerfile#FROM alpine:3.12.1
  Scenario: The image sends nginx logs to Docker and reports health
    Given the container is running
    When the operator inspects the container
    Then the access log goes to the container's standard output and the error log to its standard error
    And ports 80 and 443 are exposed
    And health is checked every 30s by requesting http://localhost/ with a 3s timeout
    And the stop signal is SIGQUIT
