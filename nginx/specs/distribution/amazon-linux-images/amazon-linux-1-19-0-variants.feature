@domain:distribution @area:amazon-linux-images @from:1-19-0/amazonlinux
Feature: Choosing an nginx 1.19.0 Amazon Linux variant
  Users choosing an nginx 1.19.0 Amazon Linux tag need to know which Lua capabilities each variant actually ships and how to read that from the image.

  Background:
    Given Given the nginx 1.19.0 Amazon Linux images of fabiocicerchia/nginx-lua

  @id:nginx.distribution.amazon-linux-images.012 @rule:distribution.amazon-linux.lua-http-scripting-in-every-variant @inferred @source:nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile#NGINX_BUILD_CONFIG
  Scenario Outline: Every Amazon Linux variant runs Lua in HTTP requests
    Given the <variant> image
    And a server location answers with content_by_lua_block that prints "hello from lua"
    When a client requests that location
    Then the response body is "hello from lua"

    Examples:
      | variant                                |
      | 1.19.0-amazonlinux2.0.20180622.1       |
      | 1.19.0-amazonlinux2.0.20180827         |
      | 1.19.0-amazonlinux2.0.20181010         |
      | 1.19.0-amazonlinux2.0.20200304.0       |
      | 1.19.0-amazonlinux2.0.20200406.0       |
      | 1.19.0-amazonlinux2018.03.0.20200318.1 |

  @id:nginx.distribution.amazon-linux-images.013 @rule:distribution.amazon-linux.extended-modules-only-on-2020-bases @inferred @source:nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile#RUN @questionable
  Scenario Outline: Extra header, stream Lua and backend client modules come only with the 2020 Amazon Linux 2 bases
    Given the <variant> image
    And a config that uses more_set_headers, a stream server with content_by_lua_block, and require "resty.redis"
    When the operator starts nginx with that config
    Then <outcome>

    Examples:
      | variant                                | outcome                                                               |
      | 1.19.0-amazonlinux2.0.20200304.0       | nginx starts and all three features work                              |
      | 1.19.0-amazonlinux2.0.20200406.0       | nginx starts and all three features work                              |
      | 1.19.0-amazonlinux2.0.20180622.1       | nginx refuses the config with an unknown directive "more_set_headers" |
      | 1.19.0-amazonlinux2.0.20180827         | nginx refuses the config with an unknown directive "more_set_headers" |
      | 1.19.0-amazonlinux2.0.20181010         | nginx refuses the config with an unknown directive "more_set_headers" |
      | 1.19.0-amazonlinux2018.03.0.20200318.1 | nginx refuses the config with an unknown directive "more_set_headers" |

  @id:nginx.distribution.amazon-linux-images.014 @rule:request-response.cookies.cookie-library-loadable @inferred @source:nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile#RUN @questionable
  Scenario Outline: The advertised Lua cookie library cannot be loaded on the 2020 Amazon Linux 2 bases
    Given the <variant> image
    And a location whose Lua code calls require "resty.cookie"
    When a client requests that location
    Then the response status is 500
    And the error log reports that module 'resty.cookie' was not found

    Examples:
      | variant                          |
      | 1.19.0-amazonlinux2.0.20200304.0 |
      | 1.19.0-amazonlinux2.0.20200406.0 |

  @id:nginx.distribution.amazon-linux-images.015 @rule:operations.image-metadata.component-version-labels @inferred @source:nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile#LABEL
  Scenario Outline: Image labels list the bundled component versions only on the 2020 Amazon Linux 2 bases
    Given the <variant> image
    When the operator inspects the image labels
    Then org.label-schema.description reads "<description>"
    And per-component labels such as versions.nginx and versions.lua-nginx-module are <component_labels>

    Examples:
      | variant                                | description                                                              | component_labels                                                          |
      | 1.19.0-amazonlinux2.0.20200406.0       | Nginx 1.19.0 with Lua support based on amazonlinux 2.0.20200406.0.       | present, e.g. versions.nginx=1.19.0 and versions.lua-nginx-module=0.10.15 |
      | 1.19.0-amazonlinux2.0.20200304.0       | Nginx 1.19.0 with Lua support based on amazonlinux 2.0.20200304.0.       | present, e.g. versions.nginx=1.19.0 and versions.lua-nginx-module=0.10.15 |
      | 1.19.0-amazonlinux2018.03.0.20200318.1 | Nginx 1.19.0 with LUA support based on amazonlinux 2018.03.0.20200318.1. | absent                                                                    |
      | 1.19.0-amazonlinux2.0.20180622.1       | Nginx 1.19.0 with LUA support based on amazonlinux 2.0.20180622.1.       | absent                                                                    |
