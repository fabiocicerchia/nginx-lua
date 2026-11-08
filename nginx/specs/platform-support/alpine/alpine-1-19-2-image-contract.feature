@domain:platform-support @area:alpine @from:1-19-2/alpine
Feature: Running the nginx 1.19.2 Alpine image
  Operators running the Alpine-based nginx 1.19.2 Lua image rely on its logging, health reporting, ports and shutdown behaviour.

  Background:
    Given Given the nginx-lua 1.19.2 image built on Alpine 3.11.6 or 3.12.0

  @id:nginx.platform-support.alpine.015 @rule:image.health.reports-unhealthy-when-root-unreachable @inferred @source:nginx/1.19.2/alpine/3.12.0/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container reports unhealthy when the web server stops answering
    Given a running nginx-lua 1.19.2 Alpine container
    When the container runtime checks its health every 30 seconds
    Then the container is healthy while http://localhost/ answers with a success status
    And the container is marked unhealthy when the request fails or takes over 3 seconds

  @id:nginx.platform-support.alpine.016 @rule:image.runtime.serves-80-443-and-quits-gracefully @inferred @source:nginx/1.19.2/alpine/3.12.0/Dockerfile#EXPOSE
  Scenario: The container serves HTTP and HTTPS ports and stops gracefully
    Given a running nginx-lua 1.19.2 Alpine container
    When the operator stops the container
    Then ports 80 and 443 are the documented listening ports
    And nginx receives a graceful quit signal and finishes in-flight requests
