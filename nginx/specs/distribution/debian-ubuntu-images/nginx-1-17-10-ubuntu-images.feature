@domain:distribution @area:debian-ubuntu-images @from:1-17-10/ubuntu
Feature: Running nginx 1.17.10 with Lua on Ubuntu
  Lets operators who standardise on Ubuntu run nginx 1.17.10 with Lua scripting on the Ubuntu release they already use, and see which release and components an image contains.

  Background:
    Given the nginx-lua image for nginx 1.17.10 on Ubuntu has been built

  @id:nginx.distribution.debian-ubuntu-images.004 @rule:distribution.ubuntu.nginx-1-17-10-with-lua-per-release @inferred @source:nginx/1.17.10/ubuntu/20.04/Dockerfile#RUN
  Scenario Outline: nginx 1.17.10 with Lua is offered on each supported Ubuntu release
    Given the operator has pulled the image tagged <tag>
    When the operator starts a container from it
    Then the operating system inside the container is Ubuntu <ubuntu>
    And nginx reports version 1.17.10
    And a location using content_by_lua_block is accepted by the configuration check

    Examples:
      | ubuntu | tag                 |
      | 18.04  | 1.17.10-ubuntu18.04 |
      | 19.10  | 1.17.10-ubuntu19.10 |
      | 20.04  | 1.17.10-ubuntu20.04 |
      | 20.10  | 1.17.10-ubuntu20.10 |

  @id:nginx.distribution.debian-ubuntu-images.005 @rule:distribution.ubuntu.bundled-nginx-modules @inferred @source:nginx/1.17.10/ubuntu/20.04/Dockerfile#RUN
  Scenario Outline: The Ubuntu images accept the bundled nginx capabilities in configuration
    Given a configuration that uses <directive>
    When the operator checks the configuration inside the container
    Then the configuration check passes for <capability>

    Examples:
      | capability                    | directive                                |
      | GeoIP country lookup          | geoip_country /usr/share/GeoIP/GeoIP.dat |
      | HTTP/2                        | listen 443 ssl http2                     |
      | subrequest authentication     | auth_request /auth                       |
      | status page                   | stub_status                              |
      | TLS pre-read for TCP proxying | ssl_preread on (in a stream server)      |
      | mail proxying                 | a mail block with an imap server         |
      | secure links                  | secure_link $arg_md5,$arg_expires        |

  @id:nginx.distribution.debian-ubuntu-images.006 @rule:observability.image-metadata.ubuntu-release-labels @inferred @source:nginx/1.17.10/ubuntu/20.04/Dockerfile#LABEL
  Scenario Outline: Image labels name the nginx version, Ubuntu release and suggested run command
    Given the operator has pulled the image tagged 1.17.10-ubuntu<ubuntu>
    When the operator inspects the image metadata
    Then the description label reads "Nginx 1.17.10 with LUA support based on ubuntu <ubuntu>."
    And the docker.cmd label reads "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.17.10-ubuntu<ubuntu>"
    And the environment lists VER_NGINX 1.17.10 and VER_LUA_NGINX_MODULE 0.10.15

    Examples:
      | ubuntu |
      | 18.04  |
      | 19.10  |
      | 20.04  |
      | 20.10  |
