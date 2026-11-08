@domain:platform-support @area:rpm-enterprise @from:1-19-2/centos
Feature: CentOS 8 nginx 1.19.2 image with Lua
  Serves operators who run the nginx-lua image on CentOS 8.1.1911 or 8.2.2004 and rely on its Lua support, log forwarding, ports and stop behaviour.

  Background:
    Given Given the operator runs the fabiocicerchia/nginx-lua image for nginx 1.19.2 on CentOS 8.1.1911 or 8.2.2004

  @id:nginx.platform-support.rpm-enterprise.011 @rule:image.lua.nginx-built-with-lua-modules @inferred @source:nginx/1.19.2/centos/8.2.2004/Dockerfile#builder
  Scenario: The image runs nginx 1.19.2 with Lua support compiled in
    Given the image has been built
    When the operator asks the image for its nginx build information
    Then the reported nginx version is 1.19.2
    And the build includes the Lua nginx module 0.10.17 and the Lua upstream module
    And the default configuration passes nginx's own configuration test

  @id:nginx.platform-support.rpm-enterprise.012 @rule:image.network.exposes-http-and-https-ports @inferred @source:nginx/1.19.2/centos/8.2.2004/Dockerfile#EXPOSE
  Scenario: The image declares ports 80 and 443
    Given the image has been built
    When the operator inspects the image
    Then ports 80 and 443 are declared as exposed

  @id:nginx.platform-support.rpm-enterprise.013 @rule:image.lifecycle.graceful-stop-on-quit-signal @inferred @source:nginx/1.19.2/centos/8.2.2004/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container shuts nginx down gracefully
    Given a running container
    When the operator stops the container
    Then the container sends SIGQUIT, so nginx finishes in-flight requests before exiting
    And dumb-init is PID 1 and forwards the signal to nginx

  @id:nginx.platform-support.rpm-enterprise.014 @rule:image.health.healthy-when-root-url-answers @inferred @source:nginx/1.19.2/centos/8.2.2004/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container reports unhealthy when http://localhost/ fails
    Given a running container
    When the orchestrator runs the health check, every 30 seconds with a 3 second timeout
    Then the container is healthy when http://localhost/ returns a successful status
    And the container is unhealthy when the request fails or returns an error status
