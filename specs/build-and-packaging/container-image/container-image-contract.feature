@domain:build-and-packaging @area:container-image @from:nginx-lua/dockerfile
Feature: Publishing a verified nginx-lua image
  Consumers of the nginx-lua image need to know what versions it contains and that a published image was tested and starts.

  Background:
    Given the nginx-lua image is being built from the repository Dockerfile

  @id:build-and-packaging.container-image.001 @rule:image.labels.report-component-versions @inferred @source:Dockerfile#LABEL @questionable
  Scenario: The image reports the versions of nginx, Lua and each bundled module
    Given an nginx-lua image built with default versions
    When a consumer inspects the image labels
    Then versions.nginx is 1.31.8 and versions.luajit2 is 2.1-20261023
    And versions.lua-nginx-module is 0.10.31 and versions.luarocks is 3.13.0
    And versions.os is 3.24.3 and org.label-schema.version is 1.31.8-alpine3.24.3
