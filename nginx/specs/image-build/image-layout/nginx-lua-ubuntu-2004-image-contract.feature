@domain:image-build @area:image-layout @from:1-20-0/ubuntu
Feature: Running nginx 1.20.0 with Lua on Ubuntu 20.04
  Operators running the nginx 1.20.0 Ubuntu 20.04 image rely on its logging, ports, health and shutdown behaviour in Docker and orchestrators.

  Background:
    Given the image fabiocicerchia/nginx-lua:1.20.0-ubuntu20.04 is running as a container

  @id:nginx.image-build.image-layout.012 @rule:image.logging.logs-go-to-container-output @inferred @source:nginx/1.20.0/ubuntu/20.04/Dockerfile#base
  Scenario: Access and error logs appear in the container log output
    Given nginx has handled a request and written an error
    When the operator reads the container logs
    Then the access log entries appear on the container's standard output
    And the error log entries appear on the container's standard error

  @id:nginx.image-build.image-layout.013 @rule:image.runtime.http-ports-and-health @inferred @source:nginx/1.20.0/ubuntu/20.04/Dockerfile#HEALTHCHECK
  Scenario: The container serves HTTP on port 80 and reports unhealthy when it stops answering
    Given the container is started with port 80 published
    When the operator checks the container health every 30 seconds
    Then the container is reported healthy while http://localhost/ answers with a success status
    And the container is reported unhealthy once the request fails or exceeds 3 seconds

  @id:nginx.image-build.image-layout.015 @rule:image.lua.lua-runtime-available @inferred @source:nginx/1.20.0/ubuntu/20.04/Dockerfile#builder @questionable
  Scenario: The image ships nginx with Lua scripting and the Lua tooling
    Given the image has been built
    When the operator inspects the installed tools
    Then nginx reports the Lua module among its build options
    And the lua command reports version 5.3
    And the luarocks command reports its version
