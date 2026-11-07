@domain:lua-scripting @area:http-lua @from:1-17-10/alpine
Feature: Scripting HTTP requests in Lua
  Operators write Lua in their nginx configuration to handle HTTP requests, using the bundled OpenResty core and LRU cache libraries.

  Background:
    Given the operator runs an nginx-lua 1.17.10 Alpine image

  @id:nginx.lua-scripting.http-lua.001 @rule:lua.http.inline-handlers @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#RUN
  Scenario: A Lua content handler answers HTTP requests
    Given the configuration has a location "/hello" with content_by_lua_block { ngx.say("hello from lua") }
    When a client requests "/hello"
    Then the response status is 200
    And the response body is "hello from lua"

  @id:nginx.lua-scripting.http-lua.002 @rule:lua.libraries.resty-core-and-lrucache-available @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#RUN
  Scenario Outline: Lua code can load the OpenResty core and LRU cache libraries
    Given the operator's Lua code requires "<library>"
    When a client sends a request handled by that Lua code
    Then the library loads without a "module not found" error
    And the request is answered by the Lua code

    Examples:
      | library        |
      | resty.core     |
      | resty.lrucache |
