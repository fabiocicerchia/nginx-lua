@domain:platform-support @area:debian-ubuntu @from:1-17-10/ubuntu
Feature: Container health reporting on Ubuntu images
  Operators running the nginx 1.17.10 Ubuntu images rely on the Docker health status to know whether nginx is serving.

  @id:nginx.platform-support.debian-ubuntu.003 @rule:image-layout.healthcheck.reports-serving-state @inferred @source:nginx/1.17.10/ubuntu/18.04/Dockerfile#HEALTHCHECK @questionable
  Scenario: A running Ubuntu container reports healthy only while nginx answers on port 80
    Given a container started from the nginx 1.17.10 Ubuntu image with nginx serving on port 80
    When the operator inspects the container health status
    Then the health status is "healthy" while http://localhost/ answers with a success status
    And the health status is "unhealthy" when the request fails
