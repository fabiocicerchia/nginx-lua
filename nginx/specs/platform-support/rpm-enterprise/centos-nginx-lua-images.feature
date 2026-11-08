@domain:platform-support @area:rpm-enterprise @from:1-17-10/centos
Feature: Running the CentOS nginx 1.17.10 Lua images
  Operators who deploy the nginx 1.17.10 images on CentOS 7.8.2003, 8.1.1911 or 8.2.2004 rely on one runtime contract: how the container starts, which ports it offers, where logs go, who it runs as and when it counts as healthy.

  Background:
    Given the nginx-lua image for nginx 1.17.10 built on a CentOS base

  @id:nginx.platform-support.rpm-enterprise.001 @rule:image.runtime.starts-nginx-foreground-on-web-ports @inferred @source:nginx/1.17.10/centos/7.8.2003/Dockerfile#ENTRYPOINT
  Scenario Outline: The container starts nginx in the foreground and offers ports 80 and 443
    Given an operator has pulled the image tagged <tag>
    When the operator starts the container with no command override
    Then nginx 1.17.10 runs as the container's main process in the foreground
    And port 80 is exposed
    And port 443 is exposed
    And a termination signal stops the container cleanly

    Examples:
      | tag                    |
      | 1.17.10-centos7.8.2003 |
      | 1.17.10-centos8.1.1911 |
      | 1.17.10-centos8.2.2004 |

  @id:nginx.platform-support.rpm-enterprise.002 @rule:image.runtime.logs-go-to-container-log-collector @inferred @source:nginx/1.17.10/centos/7.8.2003/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's log output
    Given the container is running
    When a client requests a page from nginx
    Then the access log entry appears on the container's standard output
    And nginx error messages appear on the container's standard error

  @id:nginx.platform-support.rpm-enterprise.003 @rule:image.runtime.workers-run-as-unprivileged-user @inferred @source:nginx/1.17.10/centos/7.8.2003/Dockerfile#RUN @questionable
  Scenario: nginx worker processes run as the unprivileged nginx user
    Given the container is running
    When the operator inspects the identity of the nginx worker processes
    Then workers run as user nginx with uid 32548 and group nginx
    And the nginx user has no login shell and no home directory

  @id:nginx.platform-support.rpm-enterprise.004 @rule:image.runtime.health-reflects-web-response @inferred @source:nginx/1.17.10/centos/7.8.2003/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container is reported unhealthy when nginx does not answer on port 80
    Given the container is running
    When the container platform runs its periodic health check every 30 seconds
    Then the container is reported healthy when http://localhost/ returns a success status
    And the container is reported unhealthy when the request fails, returns an HTTP error or takes more than 3 seconds

  @id:nginx.platform-support.rpm-enterprise.005 @rule:image.runtime.lua-and-geoip-modules-included @inferred @source:nginx/1.17.10/centos/7.8.2003/Dockerfile#RUN
  Scenario: nginx is built with Lua scripting support available to configurations
    Given the container is running
    When the operator runs nginx -V
    Then the build options include the Lua nginx module and the nginx development kit module
    And the build options include HTTP/2, SSL, stream and GeoIP support
