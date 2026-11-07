@domain:distribution @area:rhel-family-images @from:1-17-10/centos
Feature: Choosing a CentOS image for nginx 1.17.10
  Lets operators on CentOS 7.8, 8.1 or 8.2 pull an nginx 1.17.10 image with Lua support and know what it contains and where it runs.

  Background:
    Given the nginx-lua image for nginx 1.17.10 is published for CentOS 7.8.2003, 8.1.1911 and 8.2.2004

  @id:nginx.distribution.rhel-family-images.001 @rule:distribution.centos.base-release-identified @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#LABEL
  Scenario Outline: Each CentOS image says which nginx and CentOS release it is built on
    Given the operator has pulled the image tagged 1.17.10-centos<release>
    When the operator inspects the image labels
    Then the description label reads "Nginx 1.17.10 with LUA support based on centos <release>."
    And the suggested run command label reads "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.17.10-centos<release>"
    And the VER_NGINX environment variable is "1.17.10"

    Examples:
      | release  |
      | 7.8.2003 |
      | 8.1.1911 |
      | 8.2.2004 |

  @id:nginx.distribution.rhel-family-images.002 @rule:distribution.centos.bundled-component-versions @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#ENV
  Scenario Outline: The image advertises the version of every bundled component
    Given the operator has pulled a CentOS 1.17.10 image
    When the operator inspects the image environment
    Then <variable> is "<version>"

    Examples:
      | variable               | version      |
      | VER_LUAJIT             | 2.1-20200102 |
      | VER_LUA_NGINX_MODULE   | 0.10.15      |
      | VER_LUA_RESTY_CORE     | 0.1.17       |
      | VER_LUA_RESTY_LRUCACHE | 0.09         |
      | VER_NGX_DEVEL_KIT      | 0.3.1        |
      | VER_DUMBINIT           | 1.2.2        |

  @id:nginx.distribution.rhel-family-images.003 @rule:distribution.centos.bundled-nginx-modules @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#RUN
  Scenario Outline: The nginx build includes the HTTP, mail and stream features operators configure
    Given the operator runs a CentOS 1.17.10 container
    When the operator loads a configuration that uses <feature>
    Then nginx accepts the configuration and starts

    Examples:
      | feature                                                                          |
      | HTTPS with HTTP/2 (ssl, http2)                                                   |
      | auth_request subrequest authentication                                           |
      | secure_link protected URLs                                                       |
      | real client IP from a proxy header (realip)                                      |
      | stub_status                                                                      |
      | WebDAV, FLV, MP4, slice, random index, gzip_static, gunzip, sub_filter, addition |
      | IMAP/POP3/SMTP proxying with TLS                                                 |
      | TCP/UDP stream proxying with TLS, realip and ssl_preread                         |
      | legacy GeoIP country/city lookups (geoip_country, geoip_city)                    |

  @id:nginx.distribution.rhel-family-images.004 @rule:distribution.centos.amd64-only @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#RUN @questionable
  Scenario: The CentOS 1.17.10 images run only on amd64 hosts
    Given the operator builds the image on an arm64 host
    When the operator starts the container
    Then the container fails to start because its init process is an x86_64 binary
