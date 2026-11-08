@domain:platform-support @area:rpm-enterprise @from:1-18-0/centos
Feature: Running nginx 1.18.0 with Lua on CentOS images
  Serves operators who run the fabiocicerchia/nginx-lua 1.18.0 image on CentOS 7.8.2003, 8.1.1911 or 8.2.2004 and need the same container contract on each.

  Background:
    Given Given the image fabiocicerchia/nginx-lua:1.18.0 on a CentOS base (7.8.2003, 8.1.1911 or 8.2.2004)

  @id:nginx.platform-support.rpm-enterprise.006 @rule:image.runtime.serves-http-on-80-and-443-in-foreground @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#EXPOSE
  Scenario: The container runs nginx in the foreground and advertises ports 80 and 443
    Given an operator has pulled the CentOS 1.18.0 image
    When the operator starts the container with the documented docker run command and no extra arguments
    Then nginx 1.18.0 runs as the container's main process under dumb-init without daemonising
    And ports 80 and 443 are declared by the image
    And the documented command publishes port 80 of the container on port 80 of the host

  @id:nginx.platform-support.rpm-enterprise.007 @rule:image.runtime.logs-go-to-container-log-stream @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's log output
    Given a running container serving requests
    When the operator reads the container logs
    Then access log entries appear on the container's standard output
    And error log entries appear on the container's standard error

  @id:nginx.platform-support.rpm-enterprise.008 @rule:image.runtime.health-reflects-http-response @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container reports unhealthy when nginx does not answer on port 80
    Given a running container
    When the container runtime runs its periodic health check every 30 seconds with a 3 second timeout
    Then the container is healthy while http://localhost/ returns a success status
    And the container is unhealthy when the request fails or returns an error status

  @id:nginx.platform-support.rpm-enterprise.009 @rule:image.runtime.sigterm-stops-nginx @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container sends a termination signal that shuts nginx down
    Given a running container
    When the operator stops the container
    Then the container receives SIGTERM
    And nginx exits and the container stops

  @id:nginx.platform-support.rpm-enterprise.010 @rule:image.nginx.lua-and-geoip-modules-compiled-in @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#RUN
  Scenario: The nginx binary ships with Lua support and the documented module set
    Given the CentOS 1.18.0 image
    When the operator runs nginx -V in the container
    Then the build options include the Lua nginx module 0.10.15 and the nginx development kit 0.3.1
    And the build options include http_ssl, http_v2, http_geoip, stream and mail modules
    And nginx runs as user nginx (uid 32548)
