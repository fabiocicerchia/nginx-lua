@domain:lua-scripting @area:http-lua @from:1-18-0/centos
Feature: Scripting HTTP requests with Lua
  Lets users write request-handling logic in Lua inside nginx, which is the reason to pick nginx-lua over stock nginx.

  Background:
    Given the operator runs an nginx-lua 1.18.0 CentOS image

  @id:nginx.lua-scripting.http-lua.007 @rule:lua.http.inline-lua-handlers @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#RUN
  Scenario: A location can answer requests with inline Lua code
    Given a server block on port 80 has location /hello with content_by_lua_block { ngx.say("hello from lua") }
    When a client requests GET /hello
    Then the response status is 200
    And the body is "hello from lua"

  @id:nginx.lua-scripting.http-lua.008 @rule:lua.runtime.bundled-libraries-loadable @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#RUN
  Scenario Outline: Bundled Lua libraries load without extra configuration
    Given a location runs content_by_lua_block { local m = require "<library>"; ngx.say("ok") }
    When a client requests that location
    Then the response body is "ok"
    And the error log has no "module not found" entry

    Examples:
      | library        |
      | resty.core     |
      | resty.lrucache |
