@domain:operations-observability @area:image-metadata @from:1-19-0/debian
Feature: Identifying nginx 1.19.0 Debian images from their metadata
  Operators and scanners read image labels to learn what an image is and which component versions it bundles, without running it.

  Background:
    Given an operator inspects the labels of an nginx 1.19.0 Debian <variant> image

  @id:nginx.operations-observability.image-metadata.005 @rule:metadata.labels.describe-image-and-tag @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#LABEL @questionable
  Scenario Outline: The image labels name the nginx release, base OS and tag to run
    When the operator reads the image labels
    Then org.label-schema.description reads "<description>"
    And org.label-schema.docker.cmd reads "docker run -p 80:80 -d fabiocicerchia/nginx-lua:<tag>"
    And org.label-schema.version reads "<version>"

    Examples:
      | variant   | description                                              | tag                    | version                                                      |
      | 10.4-slim | Nginx 1.19.0 with Lua support based on debian 10.4-slim. | 1.19.0-debian10.4-slim | 1.19.0-debian10.4-slim                                       |
      | 10.3-slim | Nginx 1.19.0 with Lua support based on debian 10.3-slim. | 1.19.0-debian10.3-slim | 1.19.0-debian10.3-slim                                       |
      | 9.12-slim | Nginx 1.19.0 with LUA support based on debian 9.12-slim. | 1.19.0-debian9.12-slim | the BUILD_VERSION build argument, empty when it is not given |

  @id:nginx.operations-observability.image-metadata.006 @rule:metadata.labels.bundled-component-versions @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#LABEL
  Scenario: Extended Debian images list every bundled component version in labels and environment
    Given the variant is 10.3-slim or 10.4-slim
    When the operator reads the image labels
    Then versions.nginx is 1.19.0, versions.os is the Debian tag and versions.extended is 1
    And each bundled library has a versions.<name> label, e.g. versions.lua-nginx-module=0.10.15 and versions.lua-resty-redis=0.27
    And the same versions are available inside the container as VER_* environment variables
