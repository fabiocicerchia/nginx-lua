@domain:request-response @area:cookies @from:1-19-1/debian
Feature: Reading and setting cookies from Lua
  Lua script authors expect the cookie library the image advertises to be loadable.

  @id:nginx.request-response.cookies.001 @rule:lua.cookies.library-available @inferred @source:nginx/1.19.1/debian/10.5-slim/Dockerfile#RUN @questionable
  Scenario: The advertised Lua cookie library cannot be loaded in the 1.19.1 Debian images
    Given the image label versions.lua-resty-cookie lists a version
    And a location runs a Lua script that requires "resty.cookie"
    When a client requests that location
    Then the script fails with module 'resty.cookie' not found
    And the client receives status 500
