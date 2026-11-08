@domain:platform-support @area:debian-ubuntu @from:1-17-10/debian
Feature: Running the nginx 1.17.10 Debian slim images
  Operators who deploy the nginx 1.17.10 Lua images on Debian 8.11, 9.12, 10.2, 10.3 or 10.4 slim need them to start nginx in the foreground and report their health reliably.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.17.10 Debian slim image

  @id:nginx.platform-support.debian-ubuntu.001 @rule:platform-support.debian-slim.runs-nginx-in-foreground @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#ENTRYPOINT
  Scenario Outline: The image runs nginx in the foreground on port 80
    Given the image fabiocicerchia/nginx-lua:1.17.10-debian<version> built on debian:<version>
    When the operator starts a container with no command override
    Then nginx runs as the main process under dumb-init
    And nginx stays in the foreground so the container lives while nginx lives
    And ports 80 and 443 are declared as exposed

    Examples:
      | version   |
      | 8.11-slim |
      | 9.12-slim |
      | 10.2-slim |
      | 10.3-slim |
      | 10.4-slim |

  @id:nginx.platform-support.debian-ubuntu.002 @rule:platform-support.debian-slim.healthcheck-reports-nginx-health @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container reports healthy only while nginx answers on port 80
    Given nginx is serving the default site on port 80
    When the container runtime runs the periodic health check
    Then the health check requests http://localhost/ with a 3 second timeout every 30 seconds
    And repeated failed requests (no answer or an HTTP error status) mark the container unhealthy
