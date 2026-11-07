@domain:distribution @area:rhel-family-images @from:1-19-1/centos
Feature: Running nginx 1.19.1 with Lua on CentOS 8
  Operators who standardise on CentOS 8 get an nginx 1.19.1 image with Lua support for the exact CentOS point release they run.

  Background:
    Given the operator uses the nginx-lua image for nginx 1.19.1 on CentOS 8

  @id:nginx.distribution.rhel-family-images.026 @rule:images.centos.release-tagged-image @inferred @source:nginx/1.19.1/centos/8.2.2004/Dockerfile#base
  Scenario Outline: Each CentOS 8 point release has its own image that reports which release it is built on
    Given the image is built for CentOS <centos_release>
    When the operator inspects the image metadata
    Then the label "versions.os" reads "<centos_release>"
    And the label "org.label-schema.version" reads "1.19.1-centos<centos_release>"
    And the label "versions.nginx" reads "1.19.1"
    And the environment variable DOCKER_IMAGE_OS reads "centos"

    Examples:
      | centos_release |
      | 8.1.1911       |
      | 8.2.2004       |

  @id:nginx.distribution.rhel-family-images.027 @rule:images.extended.bundled-modules @inferred @source:nginx/1.19.1/centos/8.2.2004/Dockerfile#builder @questionable
  Scenario: The extended image ships header manipulation and TCP/UDP Lua scripting alongside HTTP Lua
    Given the image is built as an extended image
    When the operator lists the nginx build configuration
    Then the configuration includes the lua-nginx-module, ngx_devel_kit, headers-more-nginx-module and stream-lua-nginx-module
    And the label "versions.extended" reads "1"

  @id:nginx.distribution.rhel-family-images.028 @rule:images.extended.non-extended-build-refused @inferred @source:nginx/1.19.1/centos/8.2.2004/Dockerfile#builder @questionable
  Scenario: A non-extended image cannot be built for this release
    Given the operator requests a non-extended build (EXTENDED_IMAGE=0)
    When the operator builds the image
    Then the build fails while fetching the bundled libraries
    And no image is produced
