@domain:image-build @area:image-layout @from:1-25-3/alpine
Feature: Alpine image runtime contract
  Gives operators a predictable container: ports, logging, health and shutdown behaviour.

  Background:
    Given the alpine nginx-lua 1.25.3 image

  @id:nginx.image-build.image-layout.039 @rule:image.layout.logs-go-to-container-output @inferred @source:nginx/1.25.3/alpine/3.19.1/Dockerfile#Dockerfile
  Scenario: Access and error logs are forwarded to the container log
    Given the container is running
    When a client requests the default site
    Then the access log line appears in the container's standard output
    And errors appear in the container's standard error

  @id:nginx.image-build.image-layout.040 @rule:image.layout.ports-health-and-graceful-stop @inferred @source:nginx/1.25.3/alpine/3.19.1/Dockerfile#Dockerfile
  Scenario: The container serves 80 and 443, reports health and stops gracefully
    Given the container is running
    When the operator inspects and stops the container
    Then ports 80 and 443 are exposed
    And health is checked every 30 seconds by requesting http://localhost/
    And the stop signal is SIGQUIT so in-flight requests finish

  @id:nginx.image-build.image-layout.041 @rule:image.layout.lua-and-modules-included @inferred @source:nginx/1.25.3/alpine/3.19.1/Dockerfile#Dockerfile
  Scenario: The image ships nginx 1.25.3 with Lua tooling
    Given the container is running
    When the operator runs nginx -V, luajit -v and luarocks --version
    Then nginx reports 1.25.3 with the lua, headers-more, njs, geoip2 and set-misc modules
    And luajit and lua both run
    And luarocks reports its version
