@domain:image-build @area:image-layout @from:1-19-5/debian
Feature: Container defaults an operator relies on
  Gives operators standard Docker behaviour: logs on the container log stream, exposed web ports and a health status.

  Background:
    Given Given the nginx-lua Debian image 1.19.5 is running

  @id:nginx.image-build.image-layout.003 @rule:image.health.reports-unhealthy-when-root-fails @inferred @source:nginx/1.19.5/debian/10.6/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when the root page does not answer successfully
    Given nginx does not return a success status for http://localhost/
    When the operator checks the container health after 30 seconds
    Then the container health is unhealthy
