@domain:distribution @area:debian-ubuntu-images @from:1-18-0/debian
Feature: Running the nginx 1.18.0 Debian slim images
  For operators who pull an nginx 1.18.0 Debian slim tag and expect a working nginx with Lua and the standard modules, running as a dedicated unprivileged user and described by its labels.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.18.0 Debian slim image (debian 8.11, 9.12, 10.2, 10.3 or 10.4)

  @id:nginx.distribution.debian-ubuntu-images.007 @rule:images.default-site.serves-welcome-page-on-port-80 @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#CMD
  Scenario: A container started with no configuration serves the stock nginx welcome page on port 80
    Given the operator supplies no configuration of their own
    When the operator starts the container with port 80 published
    Then a GET / on port 80 returns 200 with the nginx welcome page
    And nginx runs in the foreground as the container's main process
    And the image declares ports 80 and 443

  @id:nginx.distribution.debian-ubuntu-images.008 @rule:images.runtime.workers-run-as-nginx-user @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#RUN
  Scenario: nginx workers run as the unprivileged nginx user with a fixed uid and gid
    Given the container is running with the default configuration
    When the operator lists the nginx processes in the container
    Then the worker processes run as user nginx, uid 32548, group nginx, gid 32548
    And the nginx account cannot log in: its shell is /bin/false and it has no home directory

  @id:nginx.distribution.debian-ubuntu-images.009 @rule:images.lua.inline-lua-executes @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#RUN
  Scenario: Lua code in the HTTP configuration runs on requests
    Given the operator's configuration has a location whose content is produced by a Lua block printing "hello from lua"
    When a client requests that location
    Then the response body is "hello from lua"
    And nginx starts without complaining that resty.core is missing

  @id:nginx.distribution.debian-ubuntu-images.010 @rule:images.modules.bundled-modules-available @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#RUN
  Scenario Outline: Configuration can use the modules compiled into the image
    Given the operator's configuration uses the <directive> directive
    When the operator starts the container
    Then nginx accepts the configuration and starts
    And <capability> is available

    Examples:
      | directive               | capability                          |
      | http2 on a listen       | HTTP/2 over TLS                     |
      | auth_request            | subrequest-based authentication     |
      | secure_link             | secure link checking                |
      | set_real_ip_from        | real client IP from a trusted proxy |
      | geoip_country           | GeoIP (legacy) country lookup       |
      | stub_status             | the stub_status endpoint            |
      | sub_filter              | response substitution               |
      | mp4                     | MP4 pseudo-streaming                |
      | stream with ssl_preread | TCP/UDP proxying with TLS preread   |
      | mail                    | IMAP/POP3/SMTP proxying             |

  @id:nginx.distribution.debian-ubuntu-images.011 @rule:images.metadata.labels-describe-variant @inferred @source:nginx/1.18.0/debian/10.4-slim/Dockerfile#LABEL
  Scenario Outline: Image labels name the nginx version, the base OS and how to run the image
    Given the image was built from the <variant> variant with a build date, version and VCS ref
    When the operator inspects the image
    Then the description label reads "Nginx 1.18.0 with LUA support based on debian <variant>."
    And the docker.cmd label reads "docker run -p 80:80 -d fabiocicerchia/nginx-lua:<tag>"
    And the build-date, version and vcs-ref labels hold the values supplied at build time
    And environment variables give the bundled versions, e.g. VER_NGINX=1.18.0 and VER_LUA_NGINX_MODULE=0.10.15

    Examples:
      | variant   | tag                    |
      | 8.11-slim | 1.18.0-debian8.11-slim |
      | 9.12-slim | 1.18.0-debian9.12-slim |
      | 10.2-slim | 1.18.0-debian10.2-slim |
      | 10.3-slim | 1.18.0-debian10.3-slim |
      | 10.4-slim | 1.18.0-debian10.4-slim |
