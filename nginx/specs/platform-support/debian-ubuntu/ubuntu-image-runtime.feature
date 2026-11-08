@domain:platform-support @area:debian-ubuntu @from:1-19-3/ubuntu
Feature: Ubuntu image runtime behaviour
  Describes what operators get when running the nginx 1.19.3 Ubuntu 20.04 and 20.10 images.

  Background:
    Given the nginx-lua 1.19.3 image on Ubuntu 20.04 or 20.10

  @id:nginx.platform-support.debian-ubuntu.016 @rule:image.ubuntu.listens-and-reports-health @inferred @source:nginx/1.19.3/ubuntu/20.04/Dockerfile#HEALTHCHECK
  Scenario: The container exposes ports 80 and 443 and reports unhealthy when the root page fails
    Given the container is running nginx
    When the operator inspects the container health
    Then ports 80 and 443 are exposed
    And the container is marked unhealthy after the check against http://localhost/ returns a non-success status
