@domain:image-build @area:image-layout @from:1-29-4/ubuntu
Feature: Image runtime defaults
  Operators run the image with docker run and expect ports, logs and shutdown to behave like a standard nginx container.

  Background:
    Given the nginx-lua Ubuntu 24.04 image for nginx 1.29.4

  @id:nginx.image-build.image-layout.067 @rule:image-build.image-layout.container-contract @inferred @source:nginx/1.29.4/ubuntu/24.04/Dockerfile#Dockerfile
  Scenario: The container serves on ports 80 and 443, logs to the container output and stops gracefully
    Given the container is started with default settings
    When the operator inspects the running container
    Then ports 80 and 443 are exposed
    And access and error logs go to stdout and stderr
    And nginx runs in the foreground and stops gracefully on SIGQUIT
    And a health check requests http://localhost/ every 30 seconds
