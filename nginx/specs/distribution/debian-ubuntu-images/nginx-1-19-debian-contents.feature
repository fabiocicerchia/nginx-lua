@domain:distribution @area:debian-ubuntu-images @from:1-19-0/debian
Feature: What the nginx 1.19.0 Debian images contain
  Users pick an nginx 1.19.0 Debian slim tag and expect a given set of Lua capabilities and nginx modules to be available in it.

  Background:
    Given a user runs nginx 1.19.0 from the Debian <variant> image

  @id:nginx.distribution.debian-ubuntu-images.016 @rule:distribution.debian-1-19.lua-capabilities-per-variant @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#builder
  Scenario Outline: Each Debian variant ships its own set of Lua capabilities
    When the user loads Lua code that uses <capability>
    Then the capability is <availability>

    Examples:
      | variant   | capability                                                                                        | availability  |
      | 10.4-slim | Lua in HTTP phases with resty core and lrucache                                                   | available     |
      | 10.4-slim | Redis, MySQL, Memcached, DNS, shell, WebSocket, upstream healthcheck and Prometheus Lua libraries | available     |
      | 10.4-slim | more_set_headers directives and stream Lua blocks                                                 | available     |
      | 10.3-slim | Redis, MySQL, Memcached, DNS, shell, WebSocket, upstream healthcheck and Prometheus Lua libraries | available     |
      | 10.2-slim | Lua in HTTP phases with resty core and lrucache                                                   | available     |
      | 10.2-slim | Redis, MySQL, Memcached, DNS, shell, WebSocket, upstream healthcheck and Prometheus Lua libraries | not available |
      | 9.12-slim | more_set_headers directives and stream Lua blocks                                                 | not available |
      | 8.11-slim | Redis, MySQL, Memcached, DNS, shell, WebSocket, upstream healthcheck and Prometheus Lua libraries | not available |

  @id:nginx.distribution.debian-ubuntu-images.017 @rule:distribution.debian-1-19.cookie-library-missing @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#builder @questionable
  Scenario: The cookie library listed for the extended Debian images cannot be loaded
    Given the variant is 10.3-slim or 10.4-slim
    When the user's Lua code requires resty.cookie
    Then nginx reports that module 'resty.cookie' was not found
    And the image's versions.lua-resty-cookie label still lists the library

  @id:nginx.distribution.debian-ubuntu-images.018 @rule:distribution.debian-1-19.core-http-modules @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#NGINX_BUILD_CONFIG
  Scenario Outline: Every Debian variant includes the standard nginx HTTP, mail and stream modules
    When the user enables <directive> in the nginx configuration
    Then nginx accepts the configuration and starts

    Examples:
      | variant   | directive               |
      | 10.4-slim | auth_request            |
      | 10.4-slim | geoip_country           |
      | 9.12-slim | http2 on a listen       |
      | 8.11-slim | stream with ssl_preread |
      | 10.2-slim | mail with SSL           |
