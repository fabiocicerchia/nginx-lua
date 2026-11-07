@domain:operations-observability @area:image-metadata @from:1-19-1/fedora
Feature: Inspecting what an image contains
  Lets operators and auditors see from image labels which nginx, OS and bundled components an image ships, without running it.

  @id:nginx.operations-observability.image-metadata.008 @rule:operations.metadata.component-versions-in-labels @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#LABEL
  Scenario Outline: Image labels state the version of every bundled component
    Given the image 1.19.1-fedora32 built with default settings
    When the operator inspects the image labels
    Then the label <label> has the value <value>

    Examples:
      | label                       | value                                                           |
      | versions.nginx              | 1.19.1                                                          |
      | versions.os                 | 32                                                              |
      | versions.extended           | 1                                                               |
      | versions.lua-nginx-module   | 0.10.15                                                         |
      | versions.luajit2            | 2.1-20200102                                                    |
      | versions.lua-resty-redis    | 0.27                                                            |
      | versions.dumb-init          | 1.2.2                                                           |
      | org.label-schema.version    | 1.19.1-fedora32                                                 |
      | org.label-schema.docker.cmd | docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.19.1-fedora32 |
