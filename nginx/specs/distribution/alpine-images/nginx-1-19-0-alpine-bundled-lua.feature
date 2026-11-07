@domain:distribution @area:alpine-images @from:1-19-0/alpine
Feature: Lua capabilities shipped in the nginx 1.19.0 Alpine images
  Users choosing an Alpine tag need to know which Lua modules and libraries they can use without installing anything.

  Background:
    Given the user runs a fabiocicerchia/nginx-lua 1.19.0 Alpine image

  @id:nginx.distribution.alpine-images.006 @rule:image.lua.extended-bundle-per-variant @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#builder @questionable
  Scenario Outline: Only the newer Alpine variants ship the extended Lua bundle
    Given the user runs the <alpine> variant
    When the user loads a config that uses more_set_headers, a stream-block Lua handler, and requires resty.redis, resty.mysql, resty.memcached, resty.dns, resty.shell, resty.websocket, resty.upstream.healthcheck and prometheus
    Then the configuration <outcome>

    Examples:
      | alpine | outcome                                                                                |
      | 3.12.0 | is accepted and the libraries load                                                     |
      | 3.11.6 | is accepted and the libraries load                                                     |
      | 3.11.5 | is rejected: only core Lua (lua-nginx-module, resty.core, resty.lrucache) is available |
      | 3.10.5 | is rejected: only core Lua (lua-nginx-module, resty.core, resty.lrucache) is available |

  @id:nginx.distribution.alpine-images.007 @rule:image.lua.cookie-library-unavailable @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#builder @questionable
  Scenario: The cookie library listed in the image labels cannot be loaded
    Given the user runs the 3.12.0 or 3.11.6 variant
    And the image label versions.lua-resty-cookie lists a version
    When a Lua handler requires "resty.cookie"
    Then the require fails with a module-not-found error
    And the request gets a 500 response
