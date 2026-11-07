@domain:operations-observability @area:health-and-lifecycle @from:1-19-4/amazonlinux
Feature: Container health, ports and shutdown
  Orchestrators rely on the image's healthcheck, exposed ports and stop signal to run and drain nginx safely.

  Background:
    Given the operator runs the nginx-lua Amazon Linux 2 image for nginx 1.19.4 with its default command

  @id:nginx.operations-observability.health-and-lifecycle.134 @rule:container.lifecycle.healthcheck-on-http-root @inferred @source:nginx/1.19.4/amazonlinux/2.0.20200722.0/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is reported unhealthy when the HTTP root does not answer
    Given requests to http://localhost/ inside the container <outcome>
    When the container runtime runs the image healthcheck
    Then the check reports the container as <health>

    Examples:
      | outcome                     | health    |
      | return 200 within 3 seconds | healthy   |
      | return 500                  | unhealthy |
      | take longer than 3 seconds  | unhealthy |
