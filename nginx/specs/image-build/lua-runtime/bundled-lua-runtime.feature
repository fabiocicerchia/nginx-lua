@domain:image-build @area:lua-runtime @from:1-22-0/ubuntu
Feature: Bundled Lua runtime and libraries
  Lets developers use Lua scripting and common OpenResty libraries in nginx without installing anything.

  Background:
    Given Given the nginx-lua 1.22.0 image on Ubuntu 22.04

  @id:nginx.image-build.lua-runtime.001 @rule:image-build.lua-runtime.bundled-libraries @inferred @source:nginx/1.22.0/ubuntu/22.04/tpl/Makefile#deps @questionable
  Scenario Outline: Common OpenResty Lua libraries can be loaded
    Given a Lua script in nginx requires <library>
    When a client requests a location that runs the script
    Then the library loads without a module-not-found error

    Examples:
      | library                    |
      | resty.core                 |
      | resty.lrucache             |
      | resty.cookie               |
      | resty.dns.resolver         |
      | resty.memcached            |
      | resty.mysql                |
      | resty.redis                |
      | resty.shell                |
      | resty.signal               |
      | resty.upstream.healthcheck |
      | resty.websocket.client     |
      | prometheus                 |
