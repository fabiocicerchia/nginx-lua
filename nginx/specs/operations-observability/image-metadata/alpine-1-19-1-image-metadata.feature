@domain:operations-observability @area:image-metadata @from:1-19-1/alpine
Feature: Image labels listing bundled versions
  Operators and scanners can tell which nginx, OS and Lua component versions an image contains without running it.

  @id:nginx.operations-observability.image-metadata.007 @rule:operations.metadata.component-versions-labelled @inferred @source:nginx/1.19.1/alpine/3.12.0/Dockerfile#LABEL
  Scenario Outline: Each image lists its nginx, OS and component versions in its labels
    Given the nginx-lua image built for Alpine <os>
    When the operator inspects the image labels
    Then org.label-schema.version is "1.19.1-alpine<os>"
    And versions.os is "<os>" and versions.nginx is "1.19.1"
    And versions.lua-nginx-module is "0.10.15" and versions.luajit2 is "2.1-20200102"
    And versions.extended is "1"
    And the description reads "Nginx 1.19.1 with Lua support based on alpine <os>."

    Examples:
      | os     |
      | 3.11.6 |
      | 3.12.0 |
