@domain:image-build @area:image-layout @from:1-30-1/ubuntu
Feature: Image runtime defaults
  Gives operators a container that logs to the standard Docker streams and serves HTTP/HTTPS ports by default.

  Background:
    Given Given the nginx-lua image for Ubuntu 26.04

  @id:nginx.image-build.image-layout.074 @rule:image-build.image-layout.default-command-foreground @inferred @source:nginx/1.30.1/ubuntu/26.04/Dockerfile#CMD
  Scenario: The container runs nginx in the foreground and advertises ports 80 and 443
    Given no command is given
    When the operator starts the container
    Then nginx runs as the main process (daemon off)
    And ports 80 and 443 are declared
    And a graceful quit signal (SIGQUIT) stops it
