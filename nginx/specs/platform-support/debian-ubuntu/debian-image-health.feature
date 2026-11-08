@domain:platform-support @area:debian-ubuntu @from:1-18-0/debian
Feature: Container health reporting on legacy Debian images
  Serves operators running nginx 1.18.0 images on Debian 8.11 to 10.4 who rely on the container health status to detect a failed web server.

  Background:
    Given Given the operator runs the nginx-lua 1.18.0 image based on a Debian slim release

  @id:nginx.platform-support.debian-ubuntu.004 @rule:platform-support.debian.healthcheck-reports-service-state @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#HEALTHCHECK @questionable
  Scenario Outline: The container health status reflects whether nginx answers on port 80
    Given nginx is serving the default site on port 80
    When the container runtime runs the image's health check
    Then the container is reported as healthy

    Examples:
      | base_image       |
      | debian:8.11-slim |
      | debian:9.12-slim |
      | debian:10.2-slim |
      | debian:10.3-slim |
      | debian:10.4-slim |
