@domain:observability @area:image-metadata @from:nginx-lua/dockerfile
Feature: Reading image metadata labels
  Lets operators and tooling find out what nginx, OS and module versions and which build an image contains without running it.

  Background:
    Given the operator inspects the labels of the image

  @id:observability.image-metadata.001 @rule:observability.image-metadata.component-version-labels @inferred @source:Dockerfile#LABEL
  Scenario Outline: Image labels record the bundled component versions
    Given the image was built with the default version pins
    When the operator reads the label <label>
    Then its value is <value>

    Examples:
      | label                     | value               |
      | versions.nginx            | 1.31.8              |
      | versions.njs              | 1.0.2               |
      | versions.luajit2          | 2.1-20261023        |
      | versions.lua-nginx-module | 0.10.31             |
      | versions.luarocks         | 3.13.0              |
      | versions.os               | 3.24.3              |
      | org.label-schema.version  | 1.31.8-alpine3.24.3 |

  @id:observability.image-metadata.002 @rule:observability.image-metadata.build-provenance-labels @inferred @source:Dockerfile#LABEL
  Scenario: Image labels record the build date and source revision
    Given the image was built with BUILD_DATE 2026-11-07T10:00:00Z and VCS_REF 374a60cd
    When the operator reads the provenance labels
    Then org.label-schema.build-date is 2026-11-07T10:00:00Z
    And org.label-schema.vcs-ref is 374a60cd
    And org.label-schema.vcs-url is https://github.com/fabiocicerchia/nginx-lua

  @id:observability.image-metadata.003 @rule:observability.image-metadata.target-platform-labels @inferred @source:Dockerfile#LABEL @questionable
  Scenario: Target platform labels are empty and the description omits the architecture on default builds
    Given the image was built without an ARCH build argument
    When the operator reads the platform labels
    Then image.target.platform is empty
    And image.target.os is empty
    And image.target.arch is empty
    And org.label-schema.description reads "Nginx 1.31.8 with Lua support based on alpine () 3.24.3."
