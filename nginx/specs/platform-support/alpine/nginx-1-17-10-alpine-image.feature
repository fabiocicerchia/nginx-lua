@domain:platform-support @area:alpine @from:1-17-10/alpine
Feature: Nginx 1.17.10 with Lua on Alpine images
  Operators pulling the 1.17.10 Alpine tags get a container that serves HTTP with Lua enabled, logs to Docker and reports its own health.

  Background:
    Given a fabiocicerchia/nginx-lua 1.17.10 Alpine image is available

  @id:nginx.platform-support.alpine.001 @rule:image.alpine-1-17-10.nginx-with-lua-on-port-80 @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#CMD
  Scenario Outline: Each Alpine tag of nginx 1.17.10 starts nginx with Lua support
    Given an operator has pulled the image for the Alpine release <alpine_version>
    When the operator runs the image publishing port 80
    Then nginx 1.17.10 runs in the foreground under the dumb-init init process
    And the container accepts HTTP on port 80 and declares port 443
    And the image description names Alpine <alpine_version>

    Examples:
      | alpine_version |
      | 3.10.5         |
      | 3.11.5         |
      | 3.11.6         |
      | 3.12.0         |

  @id:nginx.platform-support.alpine.002 @rule:image.logs.forwarded-to-docker @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's Docker logs
    Given a running container from the image
    When a client requests a page from port 80
    Then the request line appears in the output of docker logs (stdout)
    And nginx errors appear in the container's error output (stderr)

  @id:nginx.platform-support.alpine.003 @rule:image.health.reports-unhealthy-when-http-fails @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#HEALTHCHECK @questionable
  Scenario: A container whose web server stops answering is reported unhealthy
    Given a running container from the image
    When the orchestrator's health check requests http://localhost/ every 30 seconds and the request fails or exceeds 3 seconds
    Then the health check fails
    And after repeated consecutive failures the container's health status becomes unhealthy
