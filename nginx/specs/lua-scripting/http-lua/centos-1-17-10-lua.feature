@domain:lua-scripting @area:http-lua @from:1-17-10/centos
Feature: Scripting nginx 1.17.10 with Lua on CentOS
  Lets developers run Lua code inside HTTP request handling using LuaJIT and the OpenResty core libraries.

  Background:
    Given the operator runs a CentOS nginx 1.17.10 container

  @id:nginx.lua-scripting.http-lua.003 @rule:lua.http.inline-lua-runs @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#RUN
  Scenario: Lua code in a location answers HTTP requests
    Given a location /hello is configured with content_by_lua_block { ngx.say("hello from ", jit.version) }
    When a client requests GET /hello
    Then the response status is 200
    And the body starts with "hello from LuaJIT 2.1"

  @id:nginx.lua-scripting.http-lua.004 @rule:lua.http.resty-core-and-lrucache-available @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#RUN
  Scenario Outline: Scripts can load the resty core and LRU cache libraries without extra setup
    Given a Lua handler calls require("<library>")
    When a client requests the location
    Then the library loads and the handler responds with status 200

    Examples:
      | library        |
      | resty.core     |
      | resty.lrucache |
