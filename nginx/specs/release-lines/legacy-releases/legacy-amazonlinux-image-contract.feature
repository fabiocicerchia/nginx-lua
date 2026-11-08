@domain:release-lines @area:legacy-releases @from:1-17-10/amazonlinux
Feature: Running the nginx 1.17.10 Amazon Linux image
  Operators running the Amazon Linux based nginx 1.17.10 image get a foreground nginx with Lua support, reachable on the standard web ports and logging to the container log.

  Background:
    Given the operator has pulled an nginx 1.17.10 Amazon Linux image of this repository

  @id:nginx.release-lines.legacy-releases.001 @rule:image.runtime.serves-web-ports-and-logs-to-container @inferred @source:nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile#HEALTHCHECK
  Scenario: The image serves on ports 80 and 443 and sends logs to the container log
    Given the operator starts the image with its default command
    When the operator inspects the running container
    Then nginx 1.17.10 runs in the foreground as the main process
    And ports 80 and 443 are declared as exposed
    And access and error logs appear in the container's standard output and standard error
