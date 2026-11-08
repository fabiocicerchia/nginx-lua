@domain:platform-support @area:rpm-enterprise @from:1-19-4/centos
Feature: Running nginx 1.19.4 with Lua on CentOS 8
  Operators who run the nginx-lua CentOS 8 image for nginx 1.19.4 rely on its logging, health, shutdown and security behaviour in their container platform.

  Background:
    Given Given the nginx 1.19.4 image based on CentOS 8 is running as a container

  @id:nginx.platform-support.rpm-enterprise.017 @rule:image.runtime.healthcheck-on-port-80 @inferred @source:nginx/1.19.4/centos/8/Dockerfile#HEALTHCHECK @questionable
  Scenario: A container whose nginx does not answer on port 80 is reported unhealthy
    Given nginx is not returning a successful response on http://localhost/
    When the container platform runs the health check
    Then the container is reported as unhealthy
    And the check is retried every 30 seconds and gives up after 3 seconds per attempt

  @id:nginx.platform-support.rpm-enterprise.019 @rule:image.build.non-extended-build-skips-nginx @inferred @source:nginx/1.19.4/centos/8/Dockerfile#builder @questionable
  Scenario: Building with the extended option off does not produce a usable nginx
    Given the image is built with EXTENDED_IMAGE set to 0
    When the operator builds the image
    Then the compile step is skipped because it sits behind the extended-image test in the same command chain
    And the build then fails when the nginx binary is copied into the final image
