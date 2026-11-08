@domain:platform-support @area:fedora @from:1-18-0/fedora
Feature: Running nginx 1.18.0 with Lua on Fedora
  Operators who deploy the nginx-lua image on a Fedora base get nginx 1.18.0 with Lua scripting that serves on the standard web ports and reports its own health.

  Background:
    Given Fedora releases 29, 30, 31, 32 and 33 each have an image built from the same recipe; only the base release differs.

  @id:nginx.platform-support.fedora.005 @rule:platform.fedora.image-tag-per-release @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#LABEL
  Scenario Outline: Each supported Fedora release has its own 1.18.0 image
    Given the nginx 1.18.0 image line is published for Fedora
    When the operator starts the image for Fedora <release>
    Then the container is based on Fedora <release>
    And its description reads "Nginx 1.18.0 with LUA support based on fedora <release>."
    And its documented run command uses the tag "1.18.0-fedora<release>"

    Examples:
      | release |
      | 29      |
      | 30      |
      | 31      |
      | 32      |
      | 33      |

  @id:nginx.platform-support.fedora.006 @rule:runtime.nginx.foreground-main-process @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#CMD
  Scenario: The container runs nginx in the foreground as its main process
    Given the Fedora image has been pulled
    When the operator starts the container with no command
    Then nginx runs in the foreground, so the container stays up while nginx runs
    And the container stops when it receives a termination signal (SIGTERM)

  @id:nginx.platform-support.fedora.007 @rule:runtime.nginx.standard-web-ports @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#EXPOSE
  Scenario: The image serves web traffic on ports 80 and 443
    Given the Fedora image has been pulled
    When the operator inspects the image's published ports
    Then port 80 is exposed
    And port 443 is exposed

  @id:nginx.platform-support.fedora.008 @rule:runtime.nginx.logs-to-container-output @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's log output
    Given the Fedora image is running
    When the operator reads the container logs
    Then access log entries appear on standard output
    And error log entries appear on standard error

  @id:nginx.platform-support.fedora.009 @rule:runtime.nginx.health-reporting @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when nginx stops answering on port 80
    Given the Fedora image is running
    When the container runtime runs its periodic health check and nginx does not return a successful response at http://localhost/
    Then the check fails
    And the container is reported as unhealthy
    And the check runs every 30 seconds and times out after 3 seconds

  @id:nginx.platform-support.fedora.010 @rule:runtime.nginx.lua-scripting-available @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#RUN
  Scenario: nginx in the image can run Lua scripts
    Given the Fedora image is running
    When the operator configures a location that runs Lua code and requests it
    Then nginx loads the configuration with the Lua directives accepted
    And the response is produced by the Lua code
