@domain:platform-support @area:debian-ubuntu @from:1-18-0/ubuntu
Feature: Nginx 1.18.0 with Lua on Ubuntu
  Gives operators a ready-to-run nginx 1.18.0 image with Lua scripting for each supported Ubuntu release.

  Background:
    Given The image is published as fabiocicerchia/nginx-lua:1.18.0-ubuntu<release>

  @id:nginx.platform-support.debian-ubuntu.005 @rule:platform.ubuntu.nginx-1-18-image-per-release @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#FROM @questionable
  Scenario Outline: Nginx 1.18.0 is offered on each supported Ubuntu release
    Given the nginx-lua project lists Ubuntu release <release> for nginx 1.18.0
    When the operator pulls fabiocicerchia/nginx-lua:1.18.0-ubuntu<release>
    Then the image is based on Ubuntu <release>
    And the image description reads "Nginx 1.18.0 with LUA support based on ubuntu <release>."

    Examples:
      | release |
      | 18.04   |
      | 19.10   |
      | 20.04   |
      | 20.10   |

  @id:nginx.platform-support.debian-ubuntu.006 @rule:image.runtime.lua-scripting-available @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#RUN
  Scenario: Nginx in the image can run Lua scripts
    Given a container started from the image
    When the operator inspects the nginx build
    Then the nginx binary at /usr/sbin/nginx is version 1.18.0
    And the Lua nginx module 0.10.15 and the nginx development kit 0.3.1 are built in
    And LuaJIT 2.1-20200102 is installed under /usr/local/lib

  @id:nginx.platform-support.debian-ubuntu.007 @rule:image.runtime.serves-on-80-and-443-in-foreground @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#ENTRYPOINT
  Scenario: The container serves web traffic on ports 80 and 443 with nginx in the foreground
    Given a container started from the image with no arguments
    When the operator runs docker run -p 80:80 on the image
    Then the container exposes ports 80 and 443
    And nginx runs in the foreground as the main process under dumb-init
    And a stop signal (SIGTERM) shuts the container down

  @id:nginx.platform-support.debian-ubuntu.009 @rule:image.runtime.healthcheck-reports-liveness @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container reports itself healthy only while the default site answers
    Given a running container from the image
    When the container runtime runs the 30-second health check
    Then the container is healthy when http://localhost/ returns a success status
    And the container is unhealthy when the request fails or takes over 3 seconds
