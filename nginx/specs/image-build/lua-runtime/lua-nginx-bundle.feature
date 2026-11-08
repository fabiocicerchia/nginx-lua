@domain:image-build @area:lua-runtime @from:1-30-2/alpine
Feature: nginx with Lua and extra modules
  Gives users an nginx that can run Lua and the bundled extra modules out of the box.

  Background:
    Given Given the nginx-lua alpine image is running

  @id:nginx.image-build.lua-runtime.002 @rule:image.lua.lua-tooling-available @inferred @source:nginx/1.30.2/alpine/3.23.4/Dockerfile#smoke test
  Scenario: The image provides nginx, a debug nginx, luajit, lua and luarocks
    Given a shell in the container
    When the operator runs nginx -V, luajit -v, lua -v and luarocks --version
    Then each command prints a version
    And nginx -V lists the lua, njs, geoip2, headers-more, set-misc and stream-lua modules
    And the nginx-debug binary is installed alongside nginx
