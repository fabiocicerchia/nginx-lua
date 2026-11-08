@domain:platform-support @area:fedora @from:1-19-1/fedora
Feature: Running nginx 1.19.1 with Lua on Fedora
  Serves operators who deploy the nginx 1.19.1 Lua image on Fedora 32 or 33 and expect it to run, log and stop like a normal container.

  Background:
    Given the nginx-lua image for nginx 1.19.1 built on Fedora

  @id:nginx.platform-support.fedora.011 @rule:platform.fedora.http-and-https-ports-exposed @inferred @source:nginx/1.19.1/fedora/33/Dockerfile#EXPOSE
  Scenario: The container serves on ports 80 and 443
    Given a container started with the default command
    When the operator inspects the image's exposed ports
    Then ports 80 and 443 are exposed
    And the default command runs nginx in the foreground

  @id:nginx.platform-support.fedora.012 @rule:platform.fedora.container-health-reflects-http-response @inferred @source:nginx/1.19.1/fedora/33/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the home page fails
    Given a running container
    When the container runtime runs its health check every 30 seconds with a 3 second timeout
    Then the container is healthy while http://localhost/ answers with a success status
    And the container is unhealthy when the request fails or returns an error status

  @id:nginx.platform-support.fedora.013 @rule:platform.fedora.graceful-stop @inferred @source:nginx/1.19.1/fedora/33/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container finishes in-flight requests first
    Given a running container with an in-flight request
    When the operator stops the container
    Then the container receives a graceful quit signal (SIGQUIT)
    And the in-flight request completes before nginx exits
