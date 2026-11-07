@domain:container-startup @area:default-config @from:1-19-4/amazonlinux
Feature: Default command, user and debug binary
  Operators get a container that runs nginx in the foreground as an unprivileged nginx user, with a debug binary available for troubleshooting.

  Background:
    Given the operator runs the nginx-lua Amazon Linux 2 image for nginx 1.19.4

  @id:nginx.container-startup.default-config.051 @rule:container.default.foreground-nginx-command @inferred @source:nginx/1.19.4/amazonlinux/2.0.20200722.0/Dockerfile#CMD
  Scenario: Without a command the container runs nginx in the foreground
    Given no command is given
    When the operator starts the container
    Then the running process is "nginx -g daemon off;"
    And the container keeps running while nginx serves on port 80

  @id:nginx.container-startup.default-config.052 @rule:container.default.workers-run-as-nginx-user @inferred @source:nginx/1.19.4/amazonlinux/2.0.20200722.0/Dockerfile#RUN
  Scenario: nginx worker processes run as the unprivileged nginx user with uid 101
    Given the configuration does not set a user directive
    When the operator starts the container
    Then the worker processes run as user "nginx" with uid 101 and group "nginx" with gid 101
    And the nginx user has no login shell

  @id:nginx.container-startup.default-config.053 @rule:container.default.debug-binary-available @inferred @source:nginx/1.19.4/amazonlinux/2.0.20200722.0/tpl/Makefile#core
  Scenario: A debug build of nginx can be run instead of the release binary
    When the operator starts the container with the command "nginx-debug -g 'daemon off;'"
    Then the nginx-debug binary serves traffic
    And startup scripts in /docker-entrypoint.d run first
    And "nginx-debug -V" lists "--with-debug" in its configure arguments
