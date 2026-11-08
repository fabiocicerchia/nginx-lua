@domain:image-build @area:image-layout @from:1-25-2/alpine
Feature: Image runtime defaults
  Operators get an image that serves on standard ports, logs to the container log stream and reports its health.

  Background:
    Given the nginx 1.25.2 Alpine image

  @id:nginx.image-build.image-layout.034 @rule:image.runtime.defaults-ports-logs-health @inferred @source:nginx/1.25.2/alpine/3.18.4/Dockerfile#Dockerfile
  Scenario: The image serves on 80 and 443, logs to container output and reports health
    Given the image is started with the default command
    When the operator inspects the running container
    Then ports 80 and 443 are exposed
    And access and error logs go to container stdout and stderr
    And nginx runs in the foreground and stops on SIGQUIT
    And health fails if http://localhost/ does not respond within 3 seconds, checked every 30 seconds
