@domain:image-build @area:image-layout @from:1-29-2/alpine
Feature: Alpine image contents and runtime defaults
  Consumers of the Alpine image expect nginx with Lua, standard ports, container-friendly logs and a health probe.

  Background:
    Given Given the nginx-lua image built on Alpine 3.22.2 with nginx 1.29.2

  @id:nginx.image-build.image-layout.062 @rule:image.runtime.defaults @inferred @source:nginx/1.29.2/alpine/3.22.2/Dockerfile#HEALTHCHECK
  Scenario: The image serves on 80 and 443, logs to the container output and reports health
    Given a running container from the image
    When the operator inspects the image and its logs
    Then ports 80 and 443 are exposed
    And access and error logs go to stdout and stderr
    And the container is unhealthy after a failed "curl --fail http://localhost/" (every 30s, 3s timeout)
    And stopping sends SIGQUIT for a graceful shutdown

  @id:nginx.image-build.image-layout.063 @rule:image.nginx.includes-lua-and-modules @inferred @source:nginx/1.29.2/alpine/3.22.2/Dockerfile#NGINX_BUILD_CONFIG
  Scenario: nginx ships with Lua and the extra modules, and LuaJIT is available as lua
    Given the built image
    When the operator runs "nginx -V" and "lua -v"
    Then nginx reports version 1.29.2 with the lua, headers-more, njs, geoip2, set-misc and stream-lua modules
    And lua is the LuaJIT interpreter
    And luarocks is available
