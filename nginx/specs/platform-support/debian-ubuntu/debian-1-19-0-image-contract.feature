@domain:platform-support @area:debian-ubuntu @from:1-19-0/debian
Feature: Running nginx 1.19.0 with Lua on Debian images
  Operators who run the Debian-slim 1.19.0 images (8.11, 9.12, 10.2, 10.3, 10.4) rely on the same observable container behaviour regardless of Debian release.

  Background:
    Given the operator runs the fabiocicerchia/nginx-lua image for nginx 1.19.0 on a Debian slim base

  @id:nginx.platform-support.debian-ubuntu.010 @rule:image.runtime.lua-enabled-nginx @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#builder
  Scenario: nginx in the image can run Lua code
    Given a configuration that answers requests with a Lua content handler
    When the operator starts the container
    Then nginx -t reports the configuration is valid
    And a request to port 80 returns the response produced by the Lua handler

  @id:nginx.platform-support.debian-ubuntu.011 @rule:image.runtime.web-ports-exposed @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#EXPOSE
  Scenario: The container serves web traffic on ports 80 and 443
    Given the container is started with ports 80 and 443 published
    When a client connects to port 80 or 443
    Then the image declares ports 80 and 443 as exposed

  @id:nginx.platform-support.debian-ubuntu.012 @rule:image.runtime.health-check @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#HEALTHCHECK @questionable
  Scenario: A container that stops answering HTTP is reported unhealthy
    Given nginx no longer returns a successful response on http://localhost/
    When the container runtime runs its periodic health check
    Then the check fails
    And the container is reported as unhealthy

  @id:nginx.platform-support.debian-ubuntu.013 @rule:image.runtime.stop-signal-by-debian-release @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#STOPSIGNAL @questionable
  Scenario Outline: Stopping the container shuts nginx down in the way the Debian release dictates
    Given the container is running on <debian_release>
    When the operator stops the container
    Then the runtime sends <signal> to nginx
    And nginx shuts down <shutdown_style>

    Examples:
      | debian_release                    | signal  | shutdown_style                               |
      | 10.3-slim or 10.4-slim            | SIGQUIT | gracefully, finishing in-flight requests     |
      | 8.11-slim, 9.12-slim or 10.2-slim | SIGTERM | fast, without waiting for in-flight requests |

  @id:nginx.platform-support.debian-ubuntu.014 @rule:image.metadata.component-versions-labelled @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#LABEL
  Scenario: The image labels list the nginx and Lua component versions it contains
    Given a Debian 10.3-slim or 10.4-slim image has been built
    When the operator inspects the image labels
    Then versions.nginx is 1.19.0
    And versions.luajit2 is 2.1-20200102
    And versions.lua-nginx-module is 0.10.15
    And versions.os is the Debian tag, e.g. 10.4-slim
