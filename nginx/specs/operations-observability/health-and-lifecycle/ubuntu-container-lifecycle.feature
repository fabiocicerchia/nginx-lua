@domain:operations-observability @area:health-and-lifecycle @from:1-19-2/ubuntu
Feature: Keeping the container healthy and stopping it cleanly
  Operators running the Ubuntu nginx 1.19.2 image rely on Docker's health status, the published ports and a graceful stop so that orchestrators route traffic and roll updates without dropping requests.

  Background:
    Given Given a container started from the nginx-lua 1.19.2 Ubuntu image

  @id:nginx.operations-observability.health-and-lifecycle.108 @rule:container.health.http-healthcheck-on-localhost @inferred @source:nginx/1.19.2/ubuntu/20.04/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is healthy only while nginx answers on localhost port 80
    Given the operator has not overridden the healthcheck
    And the site served on http://localhost/ returns <status>
    When Docker runs the built-in healthcheck
    Then the check runs every 30 seconds and gives up after 3 seconds
    And the container health is reported as <health>

    Examples:
      | status                     | health    |
      | 200 OK                     | healthy   |
      | 404 Not Found              | unhealthy |
      | no answer within 3 seconds | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.109 @rule:container.lifecycle.graceful-stop-on-sigquit @inferred @source:nginx/1.19.2/ubuntu/20.04/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets nginx finish in-flight requests
    Given a client request is in progress
    When the operator stops the container
    Then nginx receives SIGQUIT
    And nginx finishes the in-progress request before exiting

  @id:nginx.operations-observability.health-and-lifecycle.110 @rule:container.network.exposes-http-and-https-ports @inferred @source:nginx/1.19.2/ubuntu/20.04/Dockerfile#EXPOSE
  Scenario: The image declares ports 80 and 443
    When the operator inspects the image
    Then ports 80/tcp and 443/tcp are listed as exposed
