@domain:operations-observability @area:image-metadata @from:1-19-2/debian
Feature: Identifying what a 1.19.2 Debian image contains
  Operators and registry tooling read image labels and environment variables to find out which nginx, OS and bundled component versions an image ships without running it.

  Background:
    Given the operator inspects a nginx-lua 1.19.2 Debian slim image

  @id:nginx.operations-observability.image-metadata.020 @rule:image.metadata.version-names-nginx-and-os @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#LABEL
  Scenario Outline: The image version label names the nginx release and the Debian base
    Given the image was built from the <variant> definition
    When the operator reads the image's labels
    Then org.label-schema.version is "<version>"
    And org.label-schema.docker.cmd is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:<version>"
    And versions.os is "<variant>" and versions.nginx is "1.19.2"

    Examples:
      | variant   | version                |
      | 10.4-slim | 1.19.2-debian10.4-slim |
      | 10.5-slim | 1.19.2-debian10.5-slim |

  @id:nginx.operations-observability.image-metadata.021 @rule:image.metadata.component-versions-advertised @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#LABEL
  Scenario Outline: Each bundled component's version can be read from the image without running it
    When the operator reads the image's labels and environment variables
    Then label <label> is "<version>"
    And environment variable <env> is "<version>"

    Examples:
      | label                            | env                     | version      |
      | versions.luajit2                 | VER_LUAJIT              | 2.1-20201002 |
      | versions.lua-nginx-module        | VER_LUA_NGINX_MODULE    | 0.10.17      |
      | versions.lua-resty-core          | VER_LUA_RESTY_CORE      | 0.1.19       |
      | versions.lua-resty-redis         | VER_OPENRESTY_REDIS     | 0.28         |
      | versions.stream-lua-nginx-module | VER_OPENRESTY_STREAMLUA | 0.0.8        |
      | versions.dumb-init               | VER_DUMBINIT            | 1.2.2        |

  @id:nginx.operations-observability.image-metadata.022 @rule:image.metadata.extended-label-matches-build @inferred @source:nginx/1.19.2/debian/10.5-slim/Dockerfile#RUN @questionable
  Scenario: An image whose extended build fell back still claims to be extended
    Given the image is built with EXTENDED_IMAGE=1
    And configuring nginx with headers-more and stream-lua fails
    When the operator reads the image's labels and checks its modules
    Then versions.extended is "1" and versions.headers-more-nginx-module and versions.stream-lua-nginx-module are still set
    And nginx -V shows neither headers-more nor stream-lua among its modules
