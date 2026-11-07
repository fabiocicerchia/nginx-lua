@domain:distribution @area:rhel-family-images @from:1-19-2/centos
Feature: Running the nginx 1.19.2 image on CentOS 8
  Gives operators an nginx 1.19.2 image with Lua support built on CentOS 8.1.1911 or 8.2.2004 that they can run, monitor and extend with the bundled Lua libraries.

  Background:
    Given Given the operator uses the nginx-lua image for nginx 1.19.2 on CentOS <os_release>

  @id:nginx.distribution.rhel-family-images.031 @rule:images.centos8-1-19-2.bundled-lua-libraries-loadable @inferred @source:nginx/1.19.2/centos/8.2.2004/Dockerfile#builder
  Scenario Outline: The bundled Lua libraries can be loaded by scripts
    Given a Lua script in the nginx configuration
    When the script requires the module "<module>"
    Then the module loads without a "module not found" error

    Examples:
      | module                     | os_release |
      | resty.core                 | 8.2.2004   |
      | resty.lrucache             | 8.2.2004   |
      | resty.dns.resolver         | 8.2.2004   |
      | resty.memcached            | 8.2.2004   |
      | resty.mysql                | 8.2.2004   |
      | resty.redis                | 8.2.2004   |
      | resty.shell                | 8.2.2004   |
      | resty.upstream.healthcheck | 8.2.2004   |
      | resty.websocket.server     | 8.2.2004   |
      | prometheus                 | 8.1.1911   |

  @id:nginx.distribution.rhel-family-images.032 @rule:images.centos8-1-19-2.cookie-library-not-installed @inferred @source:nginx/1.19.2/centos/8.2.2004/Dockerfile#builder @questionable
  Scenario: The advertised cookie library is not installed in the image
    Given the image label "versions.lua-resty-cookie" names a lua-resty-cookie version
    When a Lua script requires the module "resty.cookie"
    Then the script fails with a "module 'resty.cookie' not found" error
