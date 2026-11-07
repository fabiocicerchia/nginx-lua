@domain:lua-scripting @area:http-lua @from:1-18-0/alpine
Feature: Scripting nginx 1.18 with Lua
  Developers using the nginx 1.18 Alpine image can embed Lua in HTTP request handling and load the bundled resty libraries.

  Background:
    Given Given the operator uses an nginx-lua 1.18.0 Alpine image

  @id:nginx.lua-scripting.http-lua.005 @rule:lua.http.inline-lua-generates-response @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#RUN
  Scenario: Lua code in a location produces the response
    Given the operator's configuration has a location /hello whose content is produced by Lua printing "hello from lua"
    When a client requests http://localhost/hello
    Then the response status is 200
    And the response body is "hello from lua"

  @id:nginx.lua-scripting.http-lua.006 @rule:lua.libraries.resty-core-and-lrucache-loadable @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#RUN
  Scenario Outline: Bundled resty libraries can be required without extra paths
    Given the operator has not set a Lua package path
    When Lua code in a request requires "<library>"
    Then the library loads and the request returns 200

    Examples:
      | library        |
      | resty.core     |
      | resty.lrucache |
