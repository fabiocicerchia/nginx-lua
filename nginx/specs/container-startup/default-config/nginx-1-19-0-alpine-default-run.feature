@domain:container-startup @area:default-config @from:1-19-0/alpine
Feature: Default runtime of the nginx 1.19.0 Alpine image
  Operators who start the image with no arguments get nginx in the foreground, running as a fixed unprivileged user, with timezone selectable by environment.

  Background:
    Given the operator runs a fabiocicerchia/nginx-lua 1.19.0 Alpine image

  @id:nginx.container-startup.default-config.018 @rule:image.default-run.nginx-foreground-under-init @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#ENTRYPOINT
  Scenario: With no command given, nginx runs in the foreground under an init process
    Given no command is passed to the container
    When the operator starts the container
    Then dumb-init runs as the container's main process
    And nginx runs as its child with "daemon off;"
    And the container keeps running while nginx is up

  @id:nginx.container-startup.default-config.019 @rule:image.default-run.nginx-user-uid @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#NGINX_BUILD_CONFIG
  Scenario: nginx workers run as the unprivileged nginx user with a fixed id
    Given the container is running
    When the operator lists the nginx worker processes
    Then the workers run as user nginx, uid 32548, group nginx, gid 32548
    And the nginx user has no login shell

  @id:nginx.container-startup.default-config.020 @rule:image.default-run.timezone-from-env @inferred @source:nginx/1.19.0/alpine/3.12.0/Dockerfile#RUN
  Scenario: The operator can set the container timezone by environment
    Given the operator sets TZ to "Europe/Rome"
    When the operator starts the container
    Then nginx log timestamps use the Europe/Rome offset
