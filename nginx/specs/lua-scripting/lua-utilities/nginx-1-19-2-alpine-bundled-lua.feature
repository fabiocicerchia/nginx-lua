@domain:lua-scripting @area:lua-utilities @from:1-19-2/alpine
Feature: Using the bundled Lua libraries and nginx modules in the 1.19.2 Alpine image
  Developers writing Lua for this image depend on the advertised libraries and nginx modules being present so their configuration loads without extra installs.

  Background:
    Given Given the operator runs the nginx 1.19.2 Alpine image built with the default extended set

  @id:nginx.lua-scripting.lua-utilities.001 @rule:nginx.bundled.compiled-modules @inferred @source:nginx/1.19.2/alpine/3.12.0/Dockerfile#NGINX_BUILD_CONFIG
  Scenario Outline: The nginx binary includes the advertised modules
    When the operator runs "nginx -V" in the container
    Then the output lists "<module>"

    Examples:
      | module                           |
      | lua-nginx-module                 |
      | ngx_devel_kit                    |
      | lua-upstream-nginx-module        |
      | headers-more-nginx-module        |
      | stream-lua-nginx-module          |
      | --with-http_v2_module            |
      | --with-http_geoip_module         |
      | --with-stream_ssl_preread_module |
      | --with-mail_ssl_module           |
