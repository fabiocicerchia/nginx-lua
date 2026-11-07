@domain:distribution @area:amazon-linux-images @from:1-18-0/amazonlinux
Feature: Running nginx 1.18.0 with Lua on Amazon Linux
  Gives operators who standardise on Amazon Linux a ready nginx 1.18.0 image with Lua and the common nginx modules, pinned to a specific Amazon Linux release.

  Background:
    Given the operator has pulled a fabiocicerchia/nginx-lua 1.18.0 Amazon Linux image

  @id:nginx.distribution.amazon-linux-images.008 @rule:distribution.amazonlinux.variant-pinned-to-base-release @inferred @source:nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile#FROM
  Scenario Outline: Each Amazon Linux variant runs nginx 1.18.0 on the Amazon Linux release in its tag
    Given the image tag is "1.18.0-amazonlinux<base>"
    When the operator inspects the running container
    Then the operating system is Amazon Linux <base>
    And "nginx -v" reports version 1.18.0
    And the image description label reads "Nginx 1.18.0 with LUA support based on amazonlinux <base>."

    Examples:
      | base                 |
      | 2.0.20180622.1       |
      | 2.0.20180827         |
      | 2.0.20181010         |
      | 2.0.20200406.0       |
      | 2018.03.0.20200318.1 |

  @id:nginx.distribution.amazon-linux-images.009 @rule:distribution.amazonlinux.bundled-modules-available @inferred @source:nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile#RUN
  Scenario Outline: Lua, GeoIP and the standard nginx modules can be used in configuration
    Given a server configuration that uses the "<directive>" directive
    When the operator starts the container with that configuration
    Then nginx accepts the configuration and starts
    And the <capability> capability is available

    Examples:
      | directive            | capability                |
      | content_by_lua_block | Lua request scripting     |
      | geoip_country        | GeoIP country lookup      |
      | http2                | HTTP/2 over TLS           |
      | stub_status          | status page               |
      | auth_request         | subrequest authentication |
      | stream               | TCP/UDP proxying          |
      | mail                 | IMAP/POP3/SMTP proxying   |

  @id:nginx.distribution.amazon-linux-images.010 @rule:distribution.amazonlinux.nginx-user-fixed-ids @inferred @source:nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile#RUN
  Scenario: nginx workers run as the unprivileged nginx account with uid and gid 32548
    Given the default nginx configuration is in use
    When the operator lists the container's nginx worker processes
    Then the workers run as user "nginx" with uid 32548 and gid 32548
    And the nginx account has no login shell and no home directory

  @id:nginx.distribution.amazon-linux-images.011 @rule:distribution.amazonlinux.amd64-only @inferred @source:nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile#RUN @questionable
  Scenario Outline: The Amazon Linux 1.18.0 variants start only on amd64 hosts
    Given the image was built on a <arch> host
    When the operator starts the container
    Then <outcome>

    Examples:
      | arch  | outcome                                                                  |
      | amd64 | the init process starts nginx                                            |
      | arm64 | the container fails to start because the init binary is built for x86_64 |
