@domain:image-build @area:image-layout @from:1-30-1/almalinux
Feature: Image logging and ports
  Lets operators collect nginx logs with Docker and reach the server on standard ports.

  Background:
    Given the AlmaLinux 10.1 nginx-lua image

  @id:nginx.image-build.image-layout.072 @rule:image-build.image-layout.http-ports-and-healthcheck @inferred @source:nginx/1.30.1/almalinux/10.1-20260509/Dockerfile#HEALTHCHECK @questionable
  Scenario: The image serves HTTP and HTTPS ports and reports its health
    Given the container is started with docker run -p 80:80
    When the operator checks the container health
    Then ports 80 and 443 are exposed
    And health is healthy when http://localhost/ returns a success status, checked every 30s
