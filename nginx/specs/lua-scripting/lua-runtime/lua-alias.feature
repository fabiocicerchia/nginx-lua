@domain:lua-scripting @area:lua-runtime @from:1-19-10/amazonlinux
Feature: Lua command-line interpreter
  Gives script authors a `lua` command in the image for running Lua outside nginx.

  Background:
    Given the operator runs the nginx-lua 1.19.10 Amazon Linux 2 image

  @id:nginx.lua-scripting.lua-runtime.001 @rule:lua-scripting.runtime.lua-command-is-lua53 @inferred @source:nginx/1.19.10/amazonlinux/2.0.20210326.0/Dockerfile#RUN @questionable
  Scenario: The lua command runs the system Lua 5.3 interpreter, not LuaJIT
    Given a shell is open in the container
    When the operator runs "lua -v"
    Then the version reported is Lua 5.3
