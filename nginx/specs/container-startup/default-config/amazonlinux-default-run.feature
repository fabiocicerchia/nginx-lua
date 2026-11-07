@domain:container-startup @area:default-config @from:1-19-2/amazonlinux
Feature: Default runtime of the Amazon Linux image
  Operators who start the image without arguments get nginx running in the foreground as an unprivileged nginx user.

  Background:
    Given the operator runs the nginx-lua 1.19.2 Amazon Linux 2 image

  @id:nginx.container-startup.default-config.036 @rule:startup.default-run.nginx-foreground-under-init @inferred @source:nginx/1.19.2/amazonlinux/2.0.20200722.0/Dockerfile#ENTRYPOINT
  Scenario: Starting the container without a command runs nginx in the foreground
    Given the operator gives no command
    When the operator starts the container
    Then dumb-init runs as the init process
    And nginx runs in the foreground with "daemon off;" and keeps the container alive

  @id:nginx.container-startup.default-config.037 @rule:startup.default-run.nginx-system-user @inferred @source:nginx/1.19.2/amazonlinux/2.0.20200722.0/Dockerfile#RUN
  Scenario: nginx workers run as a fixed, non-login nginx user
    When the operator starts the container
    Then nginx worker processes run as user nginx and group nginx with uid and gid 32548
    And the nginx user has no login shell and no home directory
