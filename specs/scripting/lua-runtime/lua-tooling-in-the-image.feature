@domain:scripting @area:lua-runtime @from:nginx-lua/dockerfile
Feature: Using Lua and nginx modules shipped in the image
  Lets developers write Lua and JavaScript nginx logic and install more Lua modules without rebuilding nginx.

  Background:
    Given a container from the image

  @id:scripting.lua-runtime.001 @rule:web-serving.http-serving.bundled-modules @inferred @source:Dockerfile#NGINX_BUILD_CONFIG
  Scenario Outline: The shipped nginx includes the advertised scripting and protocol modules
    When the operator runs nginx -V
    Then the configure arguments include <module>

    Examples:
      | module                           |
      | lua-nginx-module                 |
      | stream-lua-nginx-module          |
      | njs                              |
      | ngx_http_geoip2_module           |
      | headers-more-nginx-module        |
      | set-misc-nginx-module            |
      | echo-nginx-module                |
      | lua-upstream-nginx-module        |
      | --with-http_v2_module            |
      | --with-http_v3_module            |
      | --with-stream_ssl_preread_module |
      | --with-mail_ssl_module           |
