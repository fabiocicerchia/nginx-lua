@domain:image-build @area:image-layout @from:1-31-1/fedora
Feature: Container health and logging
  Operators monitor the container through Docker health status and standard log streams.

  Background:
    Given the nginx-lua Fedora 44 image for nginx 1.31.1

  @id:nginx.image-build.image-layout.085 @rule:image-build.image-layout.health-reflects-http-response @inferred @source:nginx/1.31.1/fedora/44/Dockerfile#HEALTHCHECK
  Scenario: The container reports healthy only while the site answers successfully
    Given the container is running
    When Docker evaluates the health check every 30 seconds
    Then the container is healthy when http://localhost/ returns a successful status
    And the container becomes unhealthy when consecutive requests fail or take over 3 seconds
