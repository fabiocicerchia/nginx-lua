@domain:operations-observability @area:image-metadata @from:1-19-2/amazonlinux
Feature: Image metadata for Amazon Linux images
  Operators and tooling read the image labels to see which nginx, OS and component versions an image contains.

  @id:nginx.operations-observability.image-metadata.019 @rule:metadata.labels.version-and-components @inferred @source:nginx/1.19.2/amazonlinux/2.0.20200722.0/Dockerfile#LABEL
  Scenario Outline: Image labels name the nginx, OS and bundled component versions
    Given an nginx-lua 1.19.2 image built on Amazon Linux <os_tag>
    When the operator inspects the image labels
    Then org.label-schema.version is "1.19.2-amazonlinux<os_tag>"
    And org.label-schema.docker.cmd is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.19.2-amazonlinux<os_tag>"
    And versions.os is "<os_tag>" and versions.nginx is "1.19.2"
    And versions.lua-nginx-module is "0.10.17" and versions.luajit2 is "2.1-20201002"

    Examples:
      | os_tag         |
      | 2.0.20200602.0 |
      | 2.0.20200722.0 |
