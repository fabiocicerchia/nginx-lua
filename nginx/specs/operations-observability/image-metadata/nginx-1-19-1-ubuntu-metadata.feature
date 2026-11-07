@domain:operations-observability @area:image-metadata @from:1-19-1/ubuntu
Feature: Identifying what the nginx 1.19.1 Ubuntu image contains
  Operators and registry tooling read image labels and environment variables to learn which nginx, OS and Lua component versions an image ships.

  Background:
    Given the nginx 1.19.1 image was built for Ubuntu <os> with default build settings

  @id:nginx.operations-observability.image-metadata.010 @rule:images.metadata.label-schema-identity @inferred @source:nginx/1.19.1/ubuntu/20.04/Dockerfile#LABEL
  Scenario Outline: The image identifies itself with its tag and run command
    When the operator inspects the image labels
    Then label "org.label-schema.version" is "1.19.1-ubuntu<os>"
    And label "org.label-schema.docker.cmd" is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.19.1-ubuntu<os>"
    And label "org.label-schema.description" is "Nginx 1.19.1 with Lua support based on ubuntu <os>."

    Examples:
      | os    |
      | 20.04 |
      | 20.10 |

  @id:nginx.operations-observability.image-metadata.011 @rule:images.metadata.component-version-env @inferred @source:nginx/1.19.1/ubuntu/20.04/Dockerfile#base
  Scenario Outline: Component versions are readable from the container environment
    Given a container is running from the image
    When the operator lists the container's environment
    Then VER_NGINX is "1.19.1"
    And DOCKER_IMAGE_OS is "ubuntu" and DOCKER_IMAGE_TAG is "<os>"
    And LUA_LIB_DIR is "/usr/local/share/lua/5.1"

    Examples:
      | os    |
      | 20.04 |
      | 20.10 |
