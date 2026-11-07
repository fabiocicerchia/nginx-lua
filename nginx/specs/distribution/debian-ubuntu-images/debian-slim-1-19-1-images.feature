@domain:distribution @area:debian-ubuntu-images @from:1-19-1/debian
Feature: nginx 1.19.1 images on Debian 10 slim
  Users who standardise on Debian pick an nginx-lua 1.19.1 image matching their Debian point release, and can read from the image what it contains.

  @id:nginx.distribution.debian-ubuntu-images.024 @rule:distribution.debian.slim-point-release-variants @inferred @source:nginx/1.19.1/debian/10.5-slim/Dockerfile#LABEL
  Scenario Outline: Each Debian slim variant identifies its nginx version and Debian release
    Given the operator pulls the nginx-lua image tagged <tag>
    When the operator inspects the image
    Then the image is built on debian:<debian>
    And the version label reads "<tag>"
    And the os version label reads "<debian>"
    And the suggested run command is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:<tag>"

    Examples:
      | tag                    | debian    |
      | 1.19.1-debian10.3-slim | 10.3-slim |
      | 1.19.1-debian10.4-slim | 10.4-slim |
      | 1.19.1-debian10.5-slim | 10.5-slim |

  @id:nginx.distribution.debian-ubuntu-images.025 @rule:image-metadata.labels.bundled-component-versions @inferred @source:nginx/1.19.1/debian/10.5-slim/Dockerfile#LABEL
  Scenario Outline: The image labels list the version of every bundled component
    Given the operator pulls the nginx-lua 1.19.1 Debian 10.5 slim image
    When the operator inspects the image labels
    Then the label versions.<component> reads "<version>"

    Examples:
      | component               | version      |
      | nginx                   | 1.19.1       |
      | luajit2                 | 2.1-20200102 |
      | lua-nginx-module        | 0.10.15      |
      | lua-resty-core          | 0.1.17       |
      | stream-lua-nginx-module | 0.0.8rc3     |
      | dumb-init               | 1.2.2        |
      | extended                | 1            |
