@domain:distribution @area:rhel-family-images @from:1-17-10/fedora
Feature: Running nginx 1.17.10 with Lua on Fedora
  Gives operators who standardise on Fedora a ready nginx 1.17.10 image that can run Lua, tagged per Fedora release.

  Background:
    Given the operator uses the fabiocicerchia/nginx-lua image tagged 1.17.10-fedora<release>

  @id:nginx.distribution.rhel-family-images.005 @rule:distribution.fedora.release-variants-1-17-10 @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#FROM fedora:33
  Scenario Outline: Each supported Fedora release has its own nginx 1.17.10 image that says which release it uses
    Given the image tagged 1.17.10-fedora<release>
    When the operator inspects the image labels
    Then the description label reads "Nginx 1.17.10 with LUA support based on fedora <release>."
    And the suggested run command label reads "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.17.10-fedora<release>"

    Examples:
      | release |
      | 29      |
      | 30      |
      | 31      |
      | 32      |
      | 33      |

  @id:nginx.distribution.rhel-family-images.006 @rule:distribution.fedora.lua-in-http-requests @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#RUN
  Scenario: Lua code in the nginx configuration runs when requests arrive
    Given a site configured to answer a location with Lua code
    When a client requests that location
    Then the response body is the one the Lua code produced

  @id:nginx.distribution.rhel-family-images.007 @rule:distribution.fedora.bundled-nginx-modules @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#RUN
  Scenario Outline: The Fedora image ships nginx with the HTTP, stream, mail and GeoIP modules built in
    Given a configuration that uses the <module> directives
    When the operator starts the container
    Then nginx accepts the configuration and serves traffic with <module>

    Examples:
      | module             |
      | http_v2            |
      | http_ssl           |
      | http_geoip         |
      | http_auth_request  |
      | http_realip        |
      | http_stub_status   |
      | stream_ssl_preread |
      | mail_ssl           |
      | http_dav           |

  @id:nginx.distribution.rhel-family-images.008 @rule:distribution.fedora.nginx-user-fixed-ids @inferred @source:nginx/1.17.10/fedora/33/Dockerfile#RUN
  Scenario: nginx workers run as the nginx user with uid and gid 32548
    Given a container started from the image
    When the operator lists the nginx processes
    Then worker processes run as the user nginx with uid 32548 and group nginx with gid 32548
    And the nginx user has no login shell
