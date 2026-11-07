@domain:distribution @area:rhel-family-images @from:1-19-3/centos
Feature: Choosing an nginx 1.19.3 CentOS 8 variant
  Operators who pick between the centos 8, 8.2.2004 and 8.1.1911 tags for nginx 1.19.3 need to know what each one ships and how it describes itself.

  Background:
    Given nginx 1.19.3 is published on CentOS 8, 8.2.2004 and 8.1.1911

  @id:nginx.distribution.rhel-family-images.037 @rule:images.centos.startup-hooks-installed @inferred @source:nginx/1.19.3/centos/8.2.2004/Dockerfile#COPY @questionable
  Scenario Outline: The IPv6 listener and template rendering startup hooks run only on the CentOS 8 tag
    Given the operator runs the <variant> image
    And the operator mounts a template in /etc/nginx/templates
    When the container starts
    Then /docker-entrypoint.d is <hooks_dir>
    And the entrypoint <hooks_outcome>

    Examples:
      | variant         | hooks_dir                                         | hooks_outcome                                                           |
      | centos 8        | a directory holding the IPv6 and envsubst scripts | runs both scripts, rendering the template and adding an IPv6 listener   |
      | centos 8.2.2004 | a single file holding only the envsubst script    | reports no files found in /docker-entrypoint.d/ and skips configuration |
      | centos 8.1.1911 | a single file holding only the envsubst script    | reports no files found in /docker-entrypoint.d/ and skips configuration |

  @id:nginx.distribution.rhel-family-images.038 @rule:images.centos.debug-binary-shipped @inferred @source:nginx/1.19.3/centos/8/Dockerfile#COPY @questionable
  Scenario Outline: The nginx-debug binary ships with the CentOS 8 and 8.2.2004 tags only
    Given the operator runs the <variant> image
    When the operator runs nginx-debug in the container
    Then <outcome>

    Examples:
      | variant         | outcome                              |
      | centos 8        | the debug build of nginx 1.19.3 runs |
      | centos 8.2.2004 | the debug build of nginx 1.19.3 runs |
      | centos 8.1.1911 | the command is not found             |

  @id:nginx.distribution.rhel-family-images.039 @rule:images.centos.legacy-geoip-module @inferred @source:nginx/1.19.3/centos/8.1.1911/Dockerfile#NGINX_BUILD_CONFIG @questionable
  Scenario Outline: Legacy GeoIP directives are accepted only on the CentOS 8.1.1911 tag
    Given the operator's configuration uses the geoip_country directive
    And the operator runs the <variant> image
    When the operator checks the configuration with nginx -t
    Then <outcome>

    Examples:
      | variant         | outcome                                             |
      | centos 8.1.1911 | the directive is recognised                         |
      | centos 8        | nginx rejects geoip_country as an unknown directive |
      | centos 8.2.2004 | nginx rejects geoip_country as an unknown directive |

  @id:nginx.distribution.rhel-family-images.040 @rule:images.metadata.labels-describe-build @inferred @source:nginx/1.19.3/centos/8/Dockerfile#LABEL @questionable
  Scenario: Image labels and environment do not carry the nginx version, OS or build details
    Given the operator pulls any nginx 1.19.3 CentOS 8 image
    When the operator inspects the image metadata
    Then org.label-schema.version is "-" instead of "1.19.3-centos8"
    And versions.nginx, versions.os, org.label-schema.build-date and org.label-schema.vcs-ref are empty
    And the image environment has no VER_NGINX or other component version variables
