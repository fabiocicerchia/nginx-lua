@domain:operations-observability @area:image-metadata @from:1-17-10/alpine
Feature: Image metadata for nginx 1.17.10 Alpine
  Operators and registries read image labels and environment to learn which nginx, base OS and component versions an image contains.

  @id:nginx.operations-observability.image-metadata.001 @rule:metadata.labels.describe-version-and-base @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#LABEL
  Scenario Outline: Image labels name the nginx version, the Alpine release and how to run the tag
    Given the image tag is "1.17.10-alpine<alpine>"
    When the operator inspects the image labels
    Then org.label-schema.description is "Nginx 1.17.10 with LUA support based on alpine <alpine>."
    And org.label-schema.docker.cmd is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.17.10-alpine<alpine>"
    And org.label-schema.name is "fabiocicerchia/nginx-lua"
    And the build-date, vcs-ref and version labels carry the values given at build time

    Examples:
      | alpine |
      | 3.10.5 |
      | 3.11.5 |
      | 3.11.6 |
      | 3.12.0 |

  @id:nginx.operations-observability.image-metadata.002 @rule:metadata.environment.component-versions @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#ENV @questionable
  Scenario Outline: The container environment lists the bundled component versions
    Given the operator runs an nginx-lua 1.17.10 Alpine image
    When the operator prints the container environment
    Then <variable> is "<version>"

    Examples:
      | variable               | version      |
      | VER_NGINX              | 1.17.10      |
      | VER_LUAJIT             | 2.1-20200102 |
      | VER_LUA_NGINX_MODULE   | 0.10.15      |
      | VER_LUA_RESTY_CORE     | 0.1.17       |
      | VER_LUA_RESTY_LRUCACHE | 0.09         |
      | VER_NGX_DEVEL_KIT      | 0.3.1        |
      | VER_DUMBINIT           | 1.2.2        |
