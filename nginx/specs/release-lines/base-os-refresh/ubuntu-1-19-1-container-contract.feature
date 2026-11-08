@domain:release-lines @area:base-os-refresh @from:1-19-1/ubuntu
Feature: Running the nginx 1.19.1 Ubuntu container
  Operators running the nginx 1.19.1 Lua image on Ubuntu 20.04 or 20.10 rely on how the container starts, logs, reports health and stops.

  Background:
    Given Given the nginx-lua image for nginx 1.19.1 is built on Ubuntu

  @id:nginx.release-lines.base-os-refresh.001 @rule:image.runtime.nginx-runs-in-foreground @inferred @source:nginx/1.19.1/ubuntu/20.04/Dockerfile#CMD
  Scenario: The container runs nginx in the foreground and serves on ports 80 and 443
    Given an operator has pulled the nginx-lua image for nginx 1.19.1 on Ubuntu
    When the operator starts the container without a custom command
    Then nginx runs as the container's main process in the foreground
    And the container declares ports 80 and 443

  @id:nginx.release-lines.base-os-refresh.002 @rule:image.runtime.health-reported-by-http-probe @inferred @source:nginx/1.19.1/ubuntu/20.04/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container reports unhealthy when the local web server does not answer
    Given the container is running
    When the container runtime runs its periodic health check every 30 seconds
    Then the container is healthy while http://localhost/ returns a success status
    And the container is unhealthy when the request fails or returns an error status

  @id:nginx.release-lines.base-os-refresh.004 @rule:image.platform.ubuntu-releases-ship-same-nginx-lua @inferred @source:nginx/1.19.1/ubuntu/20.10/Dockerfile#base
  Scenario Outline: Ubuntu 20.04 and 20.10 images ship the same nginx and Lua stack
    Given images for nginx 1.19.1 exist for two Ubuntu releases
    When the operator runs nginx -V in the image for <ubuntu_release>
    Then nginx reports version 1.19.1
    And the Lua module and stream Lua module are compiled in
    And the image label reports the base OS as <ubuntu_release>

    Examples:
      | ubuntu_release |
      | 20.04          |
      | 20.10          |
