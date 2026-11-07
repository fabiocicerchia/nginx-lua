@domain:distribution @area:alpine-images @from:1-18-0/alpine
Feature: Choosing an nginx 1.18 Alpine image
  Operators pick an nginx 1.18 Alpine image by Alpine release and rely on its bundled nginx modules and self-describing labels.

  Background:
    Given Given the operator uses an nginx-lua 1.18.0 Alpine image

  @id:nginx.distribution.alpine-images.003 @rule:distribution.alpine.one-image-per-alpine-release @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#FROM
  Scenario Outline: Each Alpine release has its own nginx 1.18 image
    Given the operator wants nginx 1.18.0 on Alpine <alpine>
    When the operator inspects the image fabiocicerchia/nginx-lua:1.18.0-alpine<alpine>
    Then the image is based on alpine:<alpine>
    And its description label reads "Nginx 1.18.0 with LUA support based on alpine <alpine>."
    And its docker.cmd label reads "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.18.0-alpine<alpine>"

    Examples:
      | alpine |
      | 3.10.5 |
      | 3.11.5 |
      | 3.11.6 |
      | 3.12.0 |

  @id:nginx.distribution.alpine-images.005 @rule:distribution.metadata.build-labels-and-versions @inferred @source:nginx/1.18.0/alpine/3.12.0/Dockerfile#LABEL
  Scenario: The image tells operators when, from what and with which components it was built
    Given the image was built with build date 2020-06-01T00:00:00Z, VCS ref abc1234 and version 1.18.0
    When the operator inspects the image
    Then the build-date, vcs-ref and version labels show those values
    And the vcs-url label is https://github.com/fabiocicerchia/nginx-lua
    And the environment lists VER_NGINX 1.18.0, VER_LUA_NGINX_MODULE 0.10.15, VER_LUAJIT 2.1-20200102, VER_LUA_RESTY_CORE 0.1.17, VER_LUA_RESTY_LRUCACHE 0.09 and VER_NGX_DEVEL_KIT 0.3.1
