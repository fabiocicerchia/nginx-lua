@domain:distribution @area:rhel-family-images @from:1-18-0/fedora
Feature: Running nginx 1.18.0 with Lua on Fedora
  Gives operators who standardise on Fedora a ready-to-run nginx 1.18.0 image with Lua scripting, container-friendly logging, a healthcheck and a predictable process model.

  Background:
    Given an operator runs a fabiocicerchia/nginx-lua 1.18.0 Fedora image

  @id:nginx.distribution.rhel-family-images.009 @rule:distribution.fedora.one-image-per-fedora-release @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#FROM
  Scenario Outline: Each supported Fedora release has its own nginx 1.18.0 image
    Given the operator picks the image tagged <tag>
    When the operator inspects the image
    Then the image is built on Fedora <release>
    And the description label reads "Nginx 1.18.0 with LUA support based on fedora <release>."
    And the suggested run command label is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:<tag>"

    Examples:
      | tag             | release |
      | 1.18.0-fedora29 | 29      |
      | 1.18.0-fedora30 | 30      |
      | 1.18.0-fedora31 | 31      |
      | 1.18.0-fedora32 | 32      |
      | 1.18.0-fedora33 | 33      |

  @id:nginx.distribution.rhel-family-images.010 @rule:lua-scripting.http-lua.lua-directives-available @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#RUN
  Scenario: Lua code in the nginx configuration runs on the Fedora image
    Given a server block whose location answers with a content_by_lua_block that says "hello from lua"
    When a client requests that location
    Then the response body is "hello from lua"
    And the Lua code runs on LuaJIT 2.1-20200102 with lua-nginx-module 0.10.15

  @id:nginx.distribution.rhel-family-images.011 @rule:web-server.modules.fedora-1-18-module-set @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#RUN
  Scenario Outline: The Fedora 1.18.0 image ships the standard nginx module set plus GeoIP
    Given a configuration that uses the <directive> directive
    When the operator starts the container
    Then nginx accepts the configuration because the <module> module is built in

    Examples:
      | directive                                | module             |
      | listen 443 ssl http2                     | http_v2            |
      | geoip_country /usr/share/GeoIP/GeoIP.dat | http_geoip         |
      | ssl_preread on (stream)                  | stream_ssl_preread |
      | auth_request /auth                       | http_auth_request  |
      | sub_filter                               | http_sub           |
      | dav_methods PUT DELETE                   | http_dav           |
      | stub_status                              | http_stub_status   |
      | mail with ssl                            | mail_ssl           |

  @id:nginx.distribution.rhel-family-images.012 @rule:operations.logging.logs-to-container-output @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's output
    Given nginx is serving requests with its default log paths
    When a client requests a page that does not exist
    Then the access log line for the request appears on the container's stdout
    And the error log line for the missing file appears on the container's stderr

  @id:nginx.distribution.rhel-family-images.013 @rule:operations.health.healthcheck-on-root-url @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is reported unhealthy when its home page stops answering
    Given the container is running
    When http://localhost/ inside the container <outcome>
    Then the container health status becomes <status>
    And each probe is made every 30 seconds and gives up after 3 seconds

    Examples:
      | outcome                          | status    |
      | answers with 200                 | healthy   |
      | answers with 500                 | unhealthy |
      | does not answer within 3 seconds | unhealthy |

  @id:nginx.distribution.rhel-family-images.014 @rule:operations.lifecycle.stop-sends-sigterm @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container shuts nginx down immediately
    Given nginx is serving a long-running download
    When the operator stops the container
    Then nginx receives SIGTERM through dumb-init
    And nginx exits without waiting for the download to finish

  @id:nginx.distribution.rhel-family-images.015 @rule:container-startup.default-config.default-run-as-nginx-user @inferred @source:nginx/1.18.0/fedora/33/Dockerfile#CMD
  Scenario: By default the container runs nginx in the foreground with workers as the nginx user
    Given the operator gives no command of their own
    When the operator starts the container
    Then nginx runs in the foreground as the container's main process
    And worker processes run as user and group nginx with id 32548 and no login shell
    And ports 80 and 443 are declared as exposed
