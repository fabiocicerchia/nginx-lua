@domain:platform-support @area:rpm-enterprise @from:1-19-3/centos
Feature: Running nginx-lua 1.19.3 on CentOS 8
  Operators who deploy the nginx 1.19.3 Lua image on CentOS 8 rely on its documented runtime contract: ports, logs, health, shutdown and bundled modules.

  Background:
    Given Given the operator has pulled fabiocicerchia/nginx-lua:1.19.3-centos8

  @id:nginx.platform-support.rpm-enterprise.015 @rule:image.nginx.lua-modules-included @inferred @source:nginx/1.19.3/centos/8/Dockerfile#builder @questionable
  Scenario: nginx is built with Lua support and the standard modules
    Given a CentOS 8 nginx-lua image with the extended image option enabled
    When the operator runs nginx -V
    Then the output lists nginx 1.19.3
    And the build includes the Lua, NDK, lua-upstream, headers-more and stream-lua modules
    And the build includes http_v2, http_ssl, stream and mail

  @id:nginx.platform-support.rpm-enterprise.016 @rule:image.platform.centos-point-release-tags @inferred @source:nginx/1.19.3/centos/8.1.1911/Dockerfile#base
  Scenario Outline: Each published CentOS tag is built on its matching CentOS release
    Given tags centos8, centos8.1.1911 and centos8.2.2004 for nginx 1.19.3
    When the operator pulls a tag and inspects its version label
    Then the 8 tag is based on centos:8
    And the 8.1.1911 tag is based on centos:8.1.1911
    And the 8.2.2004 tag is based on centos:8.2.2004
    And each reports version 1.19.3-centos<tag>

    Examples:
      | tag      | base image      |
      | 8        | centos:8        |
      | 8.1.1911 | centos:8.1.1911 |
      | 8.2.2004 | centos:8.2.2004 |
