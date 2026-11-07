@domain:distribution @area:debian-ubuntu-images @from:1-19-0/ubuntu
Feature: Running nginx 1.19.0 with Lua on Ubuntu
  Gives operators who standardise on Ubuntu an nginx 1.19.0 image with Lua scripting, so they know which Ubuntu release and which bundled Lua features each tag provides.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.19.0 Ubuntu image

  @id:nginx.distribution.debian-ubuntu-images.019 @rule:distribution.ubuntu-1-19-0.release-per-tag @inferred @source:nginx/1.19.0/ubuntu/20.04/Dockerfile#base
  Scenario Outline: Each 1.19.0 Ubuntu tag runs nginx 1.19.0 on its named Ubuntu release
    Given the image tag is "1.19.0-ubuntu<release>"
    When the operator asks the container for its nginx version and OS release
    Then nginx reports version 1.19.0
    And the operating system is Ubuntu <release>
    And nginx is built with Lua support

    Examples:
      | release |
      | 18.04   |
      | 19.10   |
      | 20.04   |
      | 20.10   |

  @id:nginx.distribution.debian-ubuntu-images.020 @rule:distribution.ubuntu-1-19-0.bundled-lua-libraries @inferred @source:nginx/1.19.0/ubuntu/20.04/Dockerfile#builder
  Scenario Outline: Ubuntu 20.x images bundle the extended Lua libraries and 18.04/19.10 images bundle only the core
    Given the image is built for Ubuntu <release>
    When a Lua script in the container requires "<library>"
    Then the library is <outcome>

    Examples:
      | release | library                    | outcome   |
      | 20.04   | resty.core                 | loaded    |
      | 20.04   | resty.lrucache             | loaded    |
      | 20.04   | resty.redis                | loaded    |
      | 20.04   | resty.mysql                | loaded    |
      | 20.04   | resty.memcached            | loaded    |
      | 20.04   | resty.dns.resolver         | loaded    |
      | 20.04   | resty.websocket.server     | loaded    |
      | 20.04   | resty.shell                | loaded    |
      | 20.04   | resty.upstream.healthcheck | loaded    |
      | 20.04   | prometheus                 | loaded    |
      | 20.10   | resty.redis                | loaded    |
      | 18.04   | resty.core                 | loaded    |
      | 18.04   | resty.lrucache             | loaded    |
      | 18.04   | resty.redis                | not found |
      | 19.10   | resty.mysql                | not found |

  @id:nginx.distribution.debian-ubuntu-images.021 @rule:distribution.ubuntu-1-19-0.cookie-library-missing @inferred @source:nginx/1.19.0/ubuntu/20.04/Dockerfile#builder @questionable
  Scenario: The cookie library listed for Ubuntu 20.x images cannot be loaded
    Given the image is built for Ubuntu 20.04 or 20.10
    And the image label versions.lua-resty-cookie names a lua-resty-cookie version
    When a Lua script in the container requires "resty.cookie"
    Then the require fails with module 'resty.cookie' not found

  @id:nginx.distribution.debian-ubuntu-images.022 @rule:distribution.ubuntu-1-19-0.extended-nginx-modules @inferred @source:nginx/1.19.0/ubuntu/20.04/Dockerfile#builder
  Scenario Outline: Header rewriting and TCP/UDP Lua are available only on Ubuntu 20.x images
    Given the image is built for Ubuntu <release>
    When the operator loads a configuration using more_set_headers and a stream block with content_by_lua_block
    Then the configuration test <outcome>

    Examples:
      | release | outcome                      |
      | 20.04   | passes                       |
      | 20.10   | passes                       |
      | 18.04   | fails with unknown directive |
      | 19.10   | fails with unknown directive |

  @id:nginx.distribution.debian-ubuntu-images.023 @rule:operations.image-metadata.ubuntu-1-19-0-version-labels @inferred @source:nginx/1.19.0/ubuntu/20.04/Dockerfile#base
  Scenario Outline: Ubuntu 20.x images label their nginx, OS and component versions
    Given the image is built for Ubuntu <release>
    When the operator inspects the image labels
    Then org.label-schema.version is "1.19.0-ubuntu<release>"
    And versions.nginx is "1.19.0"
    And versions.lua-nginx-module is "0.10.15"
    And versions.os is "<release>"

    Examples:
      | release |
      | 20.04   |
      | 20.10   |
