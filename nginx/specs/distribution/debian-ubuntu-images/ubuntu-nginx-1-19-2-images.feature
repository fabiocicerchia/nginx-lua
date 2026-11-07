@domain:distribution @area:debian-ubuntu-images @from:1-19-2/ubuntu
Feature: Getting nginx 1.19.2 with Lua on Ubuntu
  Users who standardise on Ubuntu get nginx 1.19.2 with the Lua runtime, OpenResty libraries and an extended set of nginx modules on Ubuntu 20.04 and 20.10.

  Background:
    Given Given the nginx-lua 1.19.2 image built on Ubuntu <ubuntu> with default build settings

  @id:nginx.distribution.debian-ubuntu-images.026 @rule:distribution.ubuntu.nginx-on-ubuntu-releases @inferred @source:nginx/1.19.2/ubuntu/20.04/Dockerfile#base
  Scenario Outline: nginx 1.19.2 is offered on Ubuntu 20.04 and 20.10
    When the operator runs "nginx -v" in the image
    Then nginx reports version 1.19.2
    And the operating system is Ubuntu <ubuntu>

    Examples:
      | ubuntu |
      | 20.04  |
      | 20.10  |

  @id:nginx.distribution.debian-ubuntu-images.028 @rule:distribution.ubuntu.bundled-lua-libraries @inferred @source:nginx/1.19.2/ubuntu/20.04/Dockerfile#builder
  Scenario Outline: Bundled Lua libraries can be loaded from Lua code
    Given a Lua block in the operator's configuration requires "<module>"
    When a client sends a request to that location
    Then the module loads without a "module not found" error

    Examples:
      | module                     |
      | resty.core                 |
      | resty.lrucache             |
      | resty.dns.resolver         |
      | resty.memcached            |
      | resty.mysql                |
      | resty.redis                |
      | resty.upstream.healthcheck |
      | resty.websocket.server     |
      | prometheus                 |
