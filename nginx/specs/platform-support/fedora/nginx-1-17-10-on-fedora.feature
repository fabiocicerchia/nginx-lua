@domain:platform-support @area:fedora @from:1-17-10/fedora
Feature: Running nginx 1.17.10 with Lua on Fedora
  Serves operators who deploy the nginx-lua image on a Fedora base (releases 29 to 33) and expect the same nginx 1.17.10 with Lua behaviour on each.

  Background:
    Given Given the operator uses the image fabiocicerchia/nginx-lua tagged 1.17.10-fedora<release>

  @id:nginx.platform-support.fedora.001 @rule:platform-support.fedora.image-per-fedora-release @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#FROM
  Scenario Outline: Each supported Fedora release has its own nginx 1.17.10 image
    Given the Fedora release is one of 29, 30, 31, 32 or 33
    When the operator runs the image published for that Fedora release
    Then the image is built on the matching Fedora release
    And the image description reads "Nginx 1.17.10 with LUA support based on fedora <release>"
    And nginx 1.17.10 is the version running

    Examples:
      | release |
      | 29      |
      | 30      |
      | 31      |
      | 32      |
      | 33      |

  @id:nginx.platform-support.fedora.002 @rule:container-runtime.image.listens-on-http-https-and-logs-to-docker @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#EXPOSE
  Scenario: The container serves on ports 80 and 443 and sends logs to Docker
    Given the container is started with port 80 published
    When the operator starts the container
    Then the container exposes ports 80 and 443
    And nginx runs in the foreground as the container's main process
    And access and error logs appear in the container log output

  @id:nginx.platform-support.fedora.003 @rule:container-runtime.image.healthcheck-reports-unhealthy-when-root-page-fails @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#HEALTHCHECK @questionable
  Scenario: A container whose root page does not answer is reported unhealthy
    Given the container is running
    When the orchestrator runs the image health check, which requests http://localhost/
    Then the container is reported healthy when the request succeeds
    And the container is reported unhealthy when the request fails or takes longer than 3 seconds
    And the check repeats every 30 seconds

  @id:nginx.platform-support.fedora.004 @rule:image-build.lua-runtime.lua-scripting-available-in-nginx @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#RUN
  Scenario: nginx in the image can run Lua code
    Given an nginx configuration uses Lua directives
    When the operator starts nginx in the container
    Then the configuration is accepted
    And Lua code runs through LuaJIT 2.1 with the resty core and lrucache libraries available
