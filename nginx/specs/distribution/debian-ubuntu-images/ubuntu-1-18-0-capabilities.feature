@domain:distribution @area:debian-ubuntu-images @from:1-18-0/ubuntu
Feature: nginx 1.18.0 with Lua on Ubuntu
  Users who pick an Ubuntu-based nginx 1.18.0 image rely on Lua scripting, a fixed set of compiled-in modules and labels that say which variant they are running.

  Background:
    Given the operator runs an nginx 1.18.0 Ubuntu image

  @id:nginx.distribution.debian-ubuntu-images.012 @rule:image.lua.inline-lua-in-http @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#RUN
  Scenario Outline: Each Ubuntu release image runs Lua code inside HTTP requests
    Given the image is built on Ubuntu <release>
    And the operator configures location "/hello" with content_by_lua_block { ngx.say("hello") }
    When a client requests "/hello"
    Then the response is 200 with body "hello"

    Examples:
      | release |
      | 18.04   |
      | 19.10   |
      | 20.04   |
      | 20.10   |

  @id:nginx.distribution.debian-ubuntu-images.013 @rule:image.modules.compiled-in-module-set @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#RUN
  Scenario Outline: The bundled nginx features can be used without loading any dynamic module
    Given the operator's config uses the <directive> directive
    When the operator starts the container
    Then nginx accepts the configuration and starts

    Examples:
      | directive            | feature                       |
      | auth_request         | subrequest authentication     |
      | set_real_ip_from     | real client IP behind proxies |
      | secure_link          | secure links                  |
      | geoip_country        | legacy GeoIP country lookup   |
      | sub_filter           | response substitution         |
      | listen 443 ssl http2 | HTTPS with HTTP/2             |
      | stub_status          | status endpoint               |
      | ssl_preread          | stream TLS preread            |
      | mail                 | IMAP/POP3/SMTP proxy          |

  @id:nginx.distribution.debian-ubuntu-images.014 @rule:image.metadata.labels-identify-variant @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#LABEL
  Scenario Outline: Image labels and environment name the base release and the bundled component versions
    Given the operator pulls the image for Ubuntu <release>
    When the operator inspects the image
    Then the description label reads "Nginx 1.18.0 with LUA support based on ubuntu <release>."
    And the docker.cmd label reads "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.18.0-ubuntu<release>"
    And the environment lists VER_NGINX=1.18.0 and VER_LUA_NGINX_MODULE=0.10.15

    Examples:
      | release |
      | 18.04   |
      | 19.10   |
      | 20.04   |
      | 20.10   |

  @id:nginx.distribution.debian-ubuntu-images.015 @rule:image.time.timezone-from-tz-env @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#RUN
  Scenario: The operator sets the container timezone with the TZ variable
    Given the operator starts the container with TZ=Europe/Rome
    When a client requests "/"
    Then the access log timestamp shows the Europe/Rome offset
