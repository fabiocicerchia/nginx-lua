@domain:lua-scripting @area:http-lua @from:1-19-1/amazonlinux
Feature: Lua and nginx capabilities in the nginx 1.19.1 Amazon Linux 2 image
  Developers writing Lua for this image need the advertised libraries and nginx modules to actually be available.

  Background:
    Given Given the operator runs a container from the extended nginx-lua 1.19.1 Amazon Linux 2 image

  @id:nginx.lua-scripting.http-lua.009 @rule:lua.libraries.bundled-resty-libraries-load @inferred @source:nginx/1.19.1/amazonlinux/2.0.20200722.0/Dockerfile#RUN
  Scenario Outline: The bundled Lua libraries can be loaded from request handlers
    Given a location runs a Lua block that does require "<module>"
    When a client requests that location
    Then the module loads with no "module not found" error
    And the response is produced by the Lua block

    Examples:
      | module                 |
      | resty.core             |
      | resty.lrucache         |
      | resty.dns.resolver     |
      | resty.memcached        |
      | resty.mysql            |
      | resty.redis            |
      | resty.websocket.server |
      | prometheus             |

  @id:nginx.lua-scripting.http-lua.010 @rule:lua.libraries.advertised-but-unloadable @inferred @source:nginx/1.19.1/amazonlinux/2.0.20200722.0/Dockerfile#RUN @questionable
  Scenario Outline: Some advertised Lua libraries cannot be loaded even though the labels list them
    Given the image labels list <label> with a version
    And a location runs a Lua block that does require "<module>"
    When a client requests that location
    Then the request fails with a Lua error: <error>

    Examples:
      | label                                   | module                     | error                           |
      | versions.lua-resty-cookie               | resty.cookie               | module 'resty.cookie' not found |
      | versions.lua-resty-upstream-healthcheck | resty.upstream.healthcheck | module 'ngx.upstream' not found |

  @id:nginx.lua-scripting.http-lua.011 @rule:nginx.modules.compiled-capabilities @inferred @source:nginx/1.19.1/amazonlinux/2.0.20200722.0/Dockerfile#NGINX_BUILD_CONFIG @questionable
  Scenario Outline: The bundled nginx is compiled with the advertised protocol and proxy modules
    Given the operator wants to use <capability>
    When the operator runs "nginx -V" in the container
    Then the build flags include "<flag>"

    Examples:
      | capability                       | flag                             |
      | HTTPS                            | --with-http_ssl_module           |
      | HTTP/2                           | --with-http_v2_module            |
      | TLS preread for stream proxying  | --with-stream_ssl_preread_module |
      | mail proxying over TLS           | --with-mail_ssl_module           |
      | legacy GeoIP country/city lookup | --with-http_geoip_module         |
      | subrequest authentication        | --with-http_auth_request_module  |
      | extra header directives          | headers-more-nginx-module        |
      | Lua in TCP/UDP streams           | stream-lua-nginx-module          |
