@domain:operations-observability @area:health-and-lifecycle @from:1-17-10/centos
Feature: Container health and shutdown
  Lets orchestrators know when the CentOS nginx 1.17.10 container is healthy, which ports it serves and how to stop it.

  Background:
    Given the operator runs a CentOS nginx 1.17.10 container

  @id:nginx.operations-observability.health-and-lifecycle.005 @rule:lifecycle.healthcheck.root-page-must-succeed @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#HEALTHCHECK @questionable
  Scenario Outline: The container is healthy only while the root page answers successfully
    Given GET http://localhost/ inside the container returns <status>
    When the container runtime runs the health check, every 30 seconds with a 3 second timeout
    Then the container is reported <health>

    Examples:
      | status                     | health    |
      | 200                        | healthy   |
      | 301                        | healthy   |
      | 404                        | unhealthy |
      | 502                        | unhealthy |
      | no answer within 3 seconds | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.006 @rule:lifecycle.ports.http-and-https-exposed @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#EXPOSE
  Scenario: The image declares ports 80 and 443
    Given the operator inspects the image
    When the operator lists the image's exposed ports
    Then ports 80/tcp and 443/tcp are listed

  @id:nginx.operations-observability.health-and-lifecycle.007 @rule:lifecycle.stop.sigterm-fast-shutdown @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container sends SIGTERM to nginx
    Given nginx is serving requests
    When the operator stops the container
    Then nginx receives SIGTERM and shuts down right away without waiting for in-flight requests
