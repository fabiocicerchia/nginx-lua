@domain:platform-support @area:rpm-enterprise @from:1-19-5/centos
Feature: Running the nginx 1.19.5 CentOS 8 image
  Operators running the CentOS 8 image of nginx 1.19.5 with Lua rely on its logging, health reporting, shutdown and ports behaving like a standard containerised nginx.

  Background:
    Given Given the image fabiocicerchia/nginx-lua for nginx 1.19.5 on CentOS 8

  @id:nginx.platform-support.rpm-enterprise.020 @rule:image.runtime.health-reported-from-root-page @inferred @source:nginx/1.19.5/centos/8/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when the root page does not answer successfully
    Given a running container from the image
    When the container runtime runs its periodic health check every 30 seconds
    Then the container is reported healthy while http://localhost/ answers with a successful status
    And the container is reported unhealthy when http://localhost/ fails or does not answer within 3 seconds

  @id:nginx.platform-support.rpm-enterprise.022 @rule:image.runtime.http-https-ports-and-foreground-default @inferred @source:nginx/1.19.5/centos/8/Dockerfile#ENTRYPOINT
  Scenario: The image serves web traffic on ports 80 and 443 and runs nginx in the foreground by default
    Given the image started with no command override
    When the operator runs the container
    Then ports 80 and 443 are declared as exposed
    And nginx runs in the foreground so the container stays up
    And the startup scripts run before nginx starts

  @id:nginx.platform-support.rpm-enterprise.023 @rule:image.metadata.labels-advertise-versions @inferred @source:nginx/1.19.5/centos/8/Dockerfile#LABEL @questionable
  Scenario: The image labels state the nginx and module versions it contains
    Given the published image for nginx 1.19.5 on CentOS 8
    When the operator inspects the image labels
    Then the label org.label-schema.version reads 1.19.5-centos8
    And the label versions.nginx reads 1.19.5
    And the label versions.lua-nginx-module reads 0.10.19
