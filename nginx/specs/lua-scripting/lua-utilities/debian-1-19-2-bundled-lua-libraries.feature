@domain:lua-scripting @area:lua-utilities @from:1-19-2/debian
Feature: Using the bundled Lua libraries in 1.19.2 Debian images
  Script authors expect every library the image advertises to be usable straight from their Lua code, with no extra install step.

  Background:
    Given the operator runs a nginx-lua 1.19.2 Debian slim image built with EXTENDED_IMAGE=1

  @id:nginx.lua-scripting.lua-utilities.002 @rule:lua.libraries.bundled-modules-requirable @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#RUN
  Scenario Outline: Bundled Lua libraries can be loaded from scripts
    When a Lua script in an HTTP location requires "<module>"
    Then the module loads without a "module not found" error

    Examples:
      | module                     |
      | resty.core                 |
      | resty.lrucache             |
      | resty.dns.resolver         |
      | resty.memcached            |
      | resty.mysql                |
      | resty.redis                |
      | resty.shell                |
      | resty.upstream.healthcheck |
      | resty.websocket.server     |
      | prometheus                 |

  @id:nginx.lua-scripting.lua-utilities.003 @rule:lua.libraries.cookie-library-available @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#RUN @questionable
  Scenario: The advertised cookie library is missing from the image
    Given the image label versions.lua-resty-cookie is "303e32e512defced053a6484bc0745cf9dc0d39e"
    When a Lua script in an HTTP location requires "resty.cookie"
    Then the script fails with a "module 'resty.cookie' not found" error

  @id:nginx.lua-scripting.lua-utilities.004 @rule:nginx.modules.extended-modules-compiled-in @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#RUN
  Scenario Outline: Extended images accept header-rewriting and stream Lua directives
    When the operator loads a configuration that uses the <directive> directive
    Then nginx accepts the configuration
    And nginx -V lists the <module> module

    Examples:
      | directive                                   | module                    |
      | more_set_headers                            | headers-more-nginx-module |
      | content_by_lua_block inside a stream server | stream-lua-nginx-module   |
      | access_by_lua_block                         | lua-nginx-module          |
