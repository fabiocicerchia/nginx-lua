@domain:distribution @area:rhel-family-images @from:1-19-0/centos
Feature: Lua components shipped in the nginx 1.19.0 CentOS images
  Users who pick a CentOS 1.19.0 tag need to know which Lua libraries and nginx modules they can use, and to be able to read the component versions from the image.

  Background:
    Given the user has pulled an nginx-lua 1.19.0 CentOS image

  @id:nginx.distribution.rhel-family-images.016 @rule:images.components.extended-lua-libraries-on-centos8 @inferred @source:nginx/1.19.0/centos/8.2.2004/Dockerfile#builder
  Scenario Outline: CentOS 8 images ship the extended Lua libraries and modules by default
    Given the image is <variant>, built with the default settings
    When the user loads <component> in their configuration
    Then <component> is available without installing anything

    Examples:
      | variant               | component                   |
      | 1.19.0-centos8.2.2004 | resty.redis                 |
      | 1.19.0-centos8.2.2004 | resty.mysql                 |
      | 1.19.0-centos8.2.2004 | resty.memcached             |
      | 1.19.0-centos8.2.2004 | resty.dns.resolver          |
      | 1.19.0-centos8.2.2004 | resty.shell                 |
      | 1.19.0-centos8.2.2004 | resty.websocket.server      |
      | 1.19.0-centos8.2.2004 | resty.upstream.healthcheck  |
      | 1.19.0-centos8.2.2004 | prometheus                  |
      | 1.19.0-centos8.1.1911 | more_set_headers directive  |
      | 1.19.0-centos8.1.1911 | stream-level Lua directives |

  @id:nginx.distribution.rhel-family-images.017 @rule:images.components.centos7-core-lua-only @inferred @source:nginx/1.19.0/centos/7.8.2003/Dockerfile#RUN @questionable
  Scenario Outline: The CentOS 7.8 image ships only the core Lua runtime
    Given the image is 1.19.0-centos7.8.2003
    When the user loads <component> in their configuration
    Then <outcome>

    Examples:
      | component                    | outcome                                                 |
      | the content_by_lua directive | it is available                                         |
      | resty.core                   | it is available                                         |
      | resty.lrucache               | it is available                                         |
      | resty.redis                  | it is not found                                         |
      | more_set_headers directive   | nginx rejects the configuration as an unknown directive |
      | stream-level Lua directives  | nginx rejects the configuration as an unknown directive |

  @id:nginx.distribution.rhel-family-images.018 @rule:images.components.cookie-library-not-installed @inferred @source:nginx/1.19.0/centos/8.2.2004/Dockerfile#builder @questionable
  Scenario: The cookie library is downloaded but not installed in CentOS 8 images
    Given the image is a CentOS 8 extended image built with the default settings
    When a script loads the resty.cookie library
    Then the library is not found on the Lua path
    And the image label versions.lua-resty-cookie still names a version

  @id:nginx.distribution.rhel-family-images.019 @rule:images.components.non-extended-build-fails @inferred @source:nginx/1.19.0/centos/8.2.2004/Dockerfile#builder @questionable
  Scenario: Building a CentOS 8 image with the extended components turned off fails
    Given the image maintainer sets EXTENDED_IMAGE to 0
    When the image maintainer builds a CentOS 8 image
    Then the build stops in the Lua library download step with a non-zero exit
    And no image is produced

  @id:nginx.distribution.rhel-family-images.020 @rule:images.components.silent-fallback-without-extra-modules @inferred @source:nginx/1.19.0/centos/8.2.2004/Dockerfile#builder @questionable
  Scenario: If the extended configure fails, the image builds without headers-more and stream Lua
    Given the extended image is being built
    And nginx configuration with headers-more and stream-lua fails
    When the image maintainer builds a CentOS 8 image
    Then the build continues with a plain configuration
    And the image has no more_set_headers or stream-level Lua directives
    And the labels still list headers-more and stream-lua versions

  @id:nginx.distribution.rhel-family-images.021 @rule:images.metadata.component-version-labels @inferred @source:nginx/1.19.0/centos/8.2.2004/Dockerfile#LABEL
  Scenario Outline: Image labels state the nginx, OS and component versions
    Given the image is <variant>
    When the operator inspects the image labels
    Then org.label-schema.description names nginx 1.19.0 and the CentOS release
    And <version_labels>

    Examples:
      | variant               | version_labels                                                                                                    |
      | 1.19.0-centos8.2.2004 | versions.nginx, versions.os, versions.extended and one versions.<component> label per bundled library are present |
      | 1.19.0-centos8.1.1911 | versions.nginx, versions.os, versions.extended and one versions.<component> label per bundled library are present |
      | 1.19.0-centos7.8.2003 | no versions.* labels are present and org.label-schema.version is the BUILD_VERSION build argument                 |
