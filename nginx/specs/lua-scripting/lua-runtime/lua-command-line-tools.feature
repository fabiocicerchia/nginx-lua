@domain:lua-scripting @area:lua-runtime @from:1-19-10/ubuntu
Feature: Lua command-line tools in the image
  Gives users a `lua` command and LuaRocks inside the container for running scripts and installing more Lua modules.

  @id:nginx.lua-scripting.lua-runtime.002 @rule:lua.runtime.cli-tools-available @inferred @source:nginx/1.19.10/ubuntu/20.04/Dockerfile#RUN @questionable
  Scenario Outline: The lua and luarocks commands are available in the container
    Given the operator has a shell in a running nginx-lua 1.19.10 Ubuntu 20.04 container
    When the operator runs "<command>"
    Then the output reports <reported>

    Examples:
      | command            | reported                |
      | lua -v             | the Lua 5.3 interpreter |
      | luarocks --version | LuaRocks 3.5.0          |
