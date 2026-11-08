@domain:platform-support @area:rpm-enterprise @from:1-27-2/almalinux
Feature: AlmaLinux image runtime contract
  Tells operators what the published AlmaLinux image exposes and how it behaves when run.

  Background:
    Given Given the nginx-lua AlmaLinux image 1.27.2 built on AlmaLinux 9.4-20240923 or 9.5-20241118

  @id:nginx.platform-support.rpm-enterprise.026 @rule:image.runtime.nginx-has-lua-and-modules @inferred @source:nginx/1.27.2/almalinux/9.5-20241118/Dockerfile#NGINX_BUILD_CONFIG
  Scenario: nginx 1.27.2 ships with Lua and the listed modules and a smoke test passes at build
    Given the image is built
    When the operator runs nginx -V and luajit -v
    Then nginx reports version 1.27.2
    And the build includes lua-nginx-module 0.10.27, njs 0.8.7, geoip2 3.4, headers-more and set-misc
    And lua and luajit report LuaJIT 2.1-20241113
