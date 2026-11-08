@domain:image-build @area:nginx-compilation @from:1-22-0/ubuntu
Feature: nginx build contents
  Tells operators which nginx modules the image supports so their configuration works as written.

  Background:
    Given Given the nginx-lua 1.22.0 image on Ubuntu 22.04

  @id:nginx.image-build.nginx-compilation.001 @rule:image-build.nginx-compilation.bundled-modules @inferred @source:nginx/1.22.0/ubuntu/22.04/Dockerfile#NGINX_BUILD_CONFIG
  Scenario Outline: The nginx binary includes Lua, headers-more and common optional modules
    Given the image has been built
    When the operator runs "nginx -V"
    Then the output shows version 1.22.0
    And the output includes <module>

    Examples:
      | module                         |
      | lua-nginx-module-0.10.20       |
      | stream-lua-nginx-module-0.0.10 |
      | headers-more-nginx-module      |
      | --with-http_ssl_module         |
      | --with-http_v2_module          |
      | --with-stream                  |
      | --with-mail                    |

  @id:nginx.image-build.nginx-compilation.002 @rule:image-build.nginx-compilation.debug-binary @inferred @source:nginx/1.22.0/ubuntu/22.04/tpl/Makefile#core
  Scenario: A debug-enabled nginx binary ships alongside the normal one
    Given the container is running
    When the operator starts the container with the command "nginx-debug -g 'daemon off;'"
    Then nginx-debug runs in the foreground
    And its build includes the debug option
