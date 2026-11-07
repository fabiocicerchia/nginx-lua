@domain:distribution @area:alpine-images @from:1-17-10/alpine
Feature: Running nginx 1.17.10 with Lua on Alpine
  Operators who pull an nginx 1.17.10 Alpine tag get the base OS release named in the tag and the same set of built-in nginx features they can configure.

  Background:
    Given the operator runs an nginx-lua 1.17.10 Alpine image

  @id:nginx.distribution.alpine-images.001 @rule:distribution.alpine.tag-matches-base-release @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#FROM
  Scenario Outline: Each 1.17.10 Alpine tag runs nginx 1.17.10 on the Alpine release it names
    Given the operator has pulled the tag "1.17.10-alpine<alpine>"
    When the operator asks the container for its nginx and OS versions
    Then nginx reports version "1.17.10"
    And the OS reports Alpine Linux "<alpine>"

    Examples:
      | alpine |
      | 3.10.5 |
      | 3.11.5 |
      | 3.11.6 |
      | 3.12.0 |

  @id:nginx.distribution.alpine-images.002 @rule:distribution.alpine.bundled-nginx-modules @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#RUN
  Scenario Outline: Configuration using the bundled nginx features is accepted
    Given the operator's configuration uses the "<directive>" directive
    When the operator tests the configuration with nginx -t
    Then nginx reports the configuration test is successful
    And no "unknown directive" error is shown for "<directive>"

    Examples:
      | directive                | feature                         |
      | stub_status              | request status page             |
      | auth_request             | subrequest authentication       |
      | secure_link              | secure links                    |
      | real_ip_header           | real client IP                  |
      | geoip_country            | legacy GeoIP country lookup     |
      | sub_filter               | response substitution           |
      | mp4                      | MP4 streaming                   |
      | dav_methods              | WebDAV                          |
      | http2 (listen parameter) | HTTP/2                          |
      | ssl_preread (stream)     | TLS preread for stream proxying |
      | mail (block)             | mail proxying                   |
