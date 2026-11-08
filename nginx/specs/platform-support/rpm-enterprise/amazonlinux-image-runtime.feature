@domain:platform-support @area:rpm-enterprise @from:1-19-8/amazonlinux
Feature: Amazon Linux nginx-lua image defaults
  Gives users a ready-to-run nginx 1.19.8 with Lua on Amazon Linux 2 whose logs and health are visible to Docker.

  Background:
    Given Given the nginx-lua image on Amazon Linux 2.0.20210219.0 with nginx 1.19.8

  @id:nginx.platform-support.rpm-enterprise.024 @rule:image-build.image-layout.healthcheck-reports-unhealthy @inferred @source:nginx/1.19.8/amazonlinux/2.0.20210219.0/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the default page does not answer
    Given the container is running
    When Docker runs the health check every 30 seconds
    Then the container is healthy when http://localhost/ answers successfully
    And the container is unhealthy when the request fails or takes over 3 seconds
