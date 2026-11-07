@domain:request-response @area:cookies @from:1-19-2/ubuntu
Feature: Handling cookies from Lua
  Lua developers expect the cookie library that the image advertises in its labels to be loadable from their scripts.

  Background:
    Given Given the nginx-lua 1.19.2 image built on Ubuntu 20.04 or 20.10 with default build settings

  @id:nginx.request-response.cookies.002 @rule:cookies.resty-cookie-advertised-but-not-installed @inferred @source:nginx/1.19.2/ubuntu/20.04/Dockerfile#builder @questionable
  Scenario: The advertised cookie library is not available to Lua code
    Given the image label versions.lua-resty-cookie is "303e32e512defced053a6484bc0745cf9dc0d39e"
    And a Lua block in the operator's configuration requires "resty.cookie"
    When a client sends a request to that location
    Then the request fails with a "module 'resty.cookie' not found" error in the error log
    And the client receives 500 Internal Server Error
