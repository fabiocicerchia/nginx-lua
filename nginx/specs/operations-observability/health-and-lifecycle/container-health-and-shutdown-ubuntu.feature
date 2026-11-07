@domain:operations-observability @area:health-and-lifecycle @from:1-19-3/ubuntu
Feature: Container health and shutdown
  Gives orchestrators a health signal, the published ports and a graceful stop for the Ubuntu nginx 1.19.3 container.

  Background:
    Given Given a container from the nginx 1.19.3 Ubuntu 20.04 image is running

  @id:nginx.operations-observability.health-and-lifecycle.128 @rule:container.lifecycle.healthcheck-on-local-root @inferred @source:nginx/1.19.3/ubuntu/20.04/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is healthy only while its own root URL answers successfully
    Given http://localhost/ inside the container answers <status>
    When the container runtime runs the health check
    Then the container is reported as <health>
    And the check runs every 30 seconds and fails if no answer comes within 3 seconds

    Examples:
      | status    | health    |
      | 200       | healthy   |
      | 503       | unhealthy |
      | no answer | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.130 @rule:container.lifecycle.exposed-ports @inferred @source:nginx/1.19.3/ubuntu/20.04/Dockerfile#EXPOSE
  Scenario: The image publishes the HTTP and HTTPS ports
    Given the operator inspects the image
    When the operator runs the container with all exposed ports published
    Then ports 80 and 443 are published
