@domain:platform-support @area:debian-ubuntu @from:1-19-3/debian
Feature: Debian 10.6 image contract
  Gives operators an nginx 1.19.3 image with Lua that listens on documented ports, logs to the container log and reports health.

  Background:
    Given the nginx-lua Debian 10.6 image is used

  @id:nginx.platform-support.debian-ubuntu.015 @rule:image.layout.healthcheck-reports-unhealthy @inferred @source:nginx/1.19.3/debian/10.6/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the default page does not answer
    Given the container is running
    When the 30-second health checks repeatedly get no successful response from http://localhost/ within 3 seconds
    Then the container health status is unhealthy
