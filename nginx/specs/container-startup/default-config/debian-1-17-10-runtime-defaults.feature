@domain:container-startup @area:default-config @from:1-17-10/debian
Feature: Runtime defaults of the nginx 1.17.10 Debian images
  Operators rely on the runtime identity, timezone handling and log destinations the image provides without extra configuration.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.17.10 Debian slim image with its default configuration

  @id:nginx.container-startup.default-config.007 @rule:images.defaults.workers-run-as-nginx-user @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#RUN
  Scenario: nginx worker processes run as the unprivileged nginx user with a fixed uid and gid
    When the container starts nginx
    Then worker processes run as user "nginx" in group "nginx"
    And the nginx user and group both have id 32548
    And the nginx user cannot log in and has no home directory

  @id:nginx.container-startup.default-config.008 @rule:images.defaults.timezone-from-environment @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#RUN
  Scenario: The operator can set the container's timezone through the environment
    Given the operator sets TZ to "Europe/Rome"
    When the container starts
    Then local times inside the container use the Europe/Rome timezone

  @id:nginx.container-startup.default-config.009 @rule:images.logging.access-and-error-to-container-streams @inferred @source:nginx/1.17.10/debian/10.4-slim/Dockerfile#RUN
  Scenario: Access logs go to the container's stdout and error logs go to its stderr
    Given a client requests http://localhost/
    When the operator reads the container logs
    Then the access log entry for the request appears on stdout
    And nginx error messages appear on stderr
