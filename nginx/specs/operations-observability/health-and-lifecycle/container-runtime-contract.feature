@domain:operations-observability @area:health-and-lifecycle @from:1-19-4/fedora
Feature: Running the nginx container in production
  Gives operators what they rely on when running the image: logs on the container streams, a health check, the exposed ports, graceful stop and a fixed nginx user.

  Background:
    Given Given a container from the nginx 1.19.4 Fedora 33 image

  @id:nginx.operations-observability.health-and-lifecycle.148 @rule:operations.lifecycle.healthcheck @inferred @source:nginx/1.19.4/fedora/33/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when its home page stops answering
    Given the container is running
    When the health check runs, every 30 seconds
    Then the container is healthy while http://localhost/ answers with a success status within 3 seconds
    And the container is unhealthy when that request fails or times out

  @id:nginx.operations-observability.health-and-lifecycle.149 @rule:operations.lifecycle.ports-and-graceful-stop @inferred @source:nginx/1.19.4/fedora/33/Dockerfile#STOPSIGNAL
  Scenario: The container exposes ports 80 and 443, runs nginx in the foreground and stops gracefully
    Given the container runs with its default command
    When the operator stops the container
    Then the image declares ports 80 and 443
    And nginx ran in the foreground as "nginx -g 'daemon off;'"
    And nginx receives SIGQUIT and finishes in-flight requests before exiting

  @id:nginx.operations-observability.health-and-lifecycle.150 @rule:container-startup.default-config.nginx-user-101 @inferred @source:nginx/1.19.4/fedora/33/Dockerfile#RUN
  Scenario: nginx worker processes run as the nginx user with uid and gid 101
    Given the container runs with its default command
    When the operator lists the nginx worker processes
    Then the workers run as user "nginx" with uid 101 and group "nginx" with gid 101
    And the nginx user has no login shell
