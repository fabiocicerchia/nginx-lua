@domain:platform-support @area:alpine @from:1-18-0/alpine
Feature: Running nginx 1.18.0 with Lua on Alpine
  Operators pulling the 1.18.0 Alpine images get a ready-to-run nginx with Lua support that logs to Docker and reports its health.

  Background:
    Given the nginx-lua image "fabiocicerchia/nginx-lua:1.18.0-alpine3.12.0" is available

  @id:nginx.platform-support.alpine.004 @rule:image.runtime.logs-to-container-output @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#ln -sf /dev/stdout /var/log/nginx/access.log
  Scenario: Access and error logs appear in the container log
    Given a container started from the image with the default command
    When the operator reads the container logs
    Then requests served by nginx appear in the container's standard output
    And nginx errors appear in the container's standard error

  @id:nginx.platform-support.alpine.005 @rule:image.runtime.health-reported @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when nginx stops answering on port 80
    Given a running container from the image
    When Docker runs its periodic health probe
    Then the container is reported healthy while http://localhost/ answers with a success status
    And the container is reported unhealthy when the request fails or takes longer than 3 seconds
    And probes run every 30 seconds

  @id:nginx.platform-support.alpine.006 @rule:image.runtime.published-ports-and-start @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#CMD
  Scenario: The image serves HTTP and HTTPS ports and runs nginx in the foreground
    Given a container started from the image with the default command
    When the operator publishes port 80 and sends a request
    Then ports 80 and 443 are declared by the image
    And nginx runs in the foreground under an init process
    And stopping the container sends SIGTERM

  @id:nginx.platform-support.alpine.007 @rule:image.nginx.lua-modules-compiled-in @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#./configure
  Scenario: nginx in the image can run Lua and ships the standard optional modules
    Given a container started from the image
    When the operator uses a configuration with Lua directives, SSL, HTTP/2, stream or mail
    Then the Lua directives are accepted by nginx 1.18.0
    And SSL, HTTP/2, stream, mail and GeoIP modules are available
