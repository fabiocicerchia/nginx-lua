@domain:distribution @area:debian-ubuntu-images @from:1-17-10/debian
Feature: Choosing an nginx 1.17.10 Debian slim image
  Users choose an nginx 1.17.10 image by Debian release and need to know which nginx features and Lua support it provides.

  @id:nginx.distribution.debian-ubuntu-images.001 @rule:images.debian.release-per-tag @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#FROM
  Scenario Outline: Each nginx 1.17.10 Debian tag is built on the Debian slim release it names
    Given the user pulls fabiocicerchia/nginx-lua:1.17.10-debian<release>
    When the user inspects the image
    Then the image is based on debian:<release>
    And its description label reads "Nginx 1.17.10 with LUA support based on debian <release>."
    And its suggested run command is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.17.10-debian<release>"

    Examples:
      | release   |
      | 8.11-slim |
      | 9.12-slim |
      | 10.2-slim |
      | 10.3-slim |
      | 10.4-slim |

  @id:nginx.distribution.debian-ubuntu-images.002 @rule:images.debian.bundled-nginx-features @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#RUN
  Scenario Outline: The image's nginx accepts configuration for its bundled modules
    Given the operator's configuration uses the <directive> directive
    When the operator starts the container
    Then nginx accepts the configuration and starts

    Examples:
      | directive               | capability                  |
      | http2 on a listen       | HTTP/2 over TLS             |
      | auth_request            | subrequest authentication   |
      | secure_link             | secure links                |
      | set_real_ip_from        | real client IP              |
      | geoip_country           | legacy GeoIP country lookup |
      | mp4                     | MP4 streaming               |
      | dav_methods             | WebDAV                      |
      | stub_status             | status endpoint             |
      | stream with ssl_preread | TCP/UDP proxying            |
      | mail with ssl           | mail proxying               |

  @id:nginx.distribution.debian-ubuntu-images.003 @rule:images.debian.lua-in-http-requests @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#RUN
  Scenario: Lua code in HTTP configuration runs with resty.core and lrucache available
    Given the operator's site has a location with content_by_lua_block that requires "resty.core" and "resty.lrucache" and says "hello"
    When a client requests that location
    Then the response body is "hello"
