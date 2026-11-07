@domain:operations-observability @area:image-metadata @from:1-19-4/centos
Feature: Reading the CentOS 8 image's version metadata
  Operators and tooling read image labels and environment to see which nginx, OS and module versions an image contains.

  Background:
    Given the operator has pulled the nginx 1.19.4 CentOS 8 image

  @id:nginx.operations-observability.image-metadata.031 @rule:image.metadata.environment-lists-versions @inferred @source:nginx/1.19.4/centos/8/Dockerfile#ENV @questionable
  Scenario: The running container's environment does not expose component versions
    Given the container is running
    When the operator lists the container's environment variables
    Then VER_NGINX, VER_LUAJIT and the other VER_* variables are absent
    And BUILD_DATE and VCS_REF are absent
    And PKG_DEPS is present
