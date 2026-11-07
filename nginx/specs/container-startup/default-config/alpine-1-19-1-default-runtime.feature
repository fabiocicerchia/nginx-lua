@domain:container-startup @area:default-config @from:1-19-1/alpine
Feature: Running nginx with its default settings
  Operators who run the Alpine nginx 1.19.1 images without extra configuration get nginx in the foreground, under an init process, running as a fixed unprivileged user.

  Background:
    Given Given a container started from an nginx-lua 1.19.1 Alpine image (alpine3.11.6 or alpine3.12.0)

  @id:nginx.container-startup.default-config.025 @rule:container.default-config.nginx-runs-in-foreground @inferred @source:nginx/1.19.1/alpine/3.12.0/Dockerfile#CMD
  Scenario: With no command, the container runs nginx in the foreground under an init process
    Given the operator has not overridden the container command
    When the operator starts the container
    Then the main process is dumb-init
    And nginx runs as its child with "daemon off;"
    And the container keeps running for as long as nginx runs

  @id:nginx.container-startup.default-config.026 @rule:container.default-config.workers-run-as-nginx-user @inferred @source:nginx/1.19.1/alpine/3.12.0/Dockerfile#NGINX_BUILD_CONFIG
  Scenario: nginx workers run as the nginx user with UID and GID 32548
    Given the shipped nginx.conf does not set a user directive
    When the operator starts the container
    Then the nginx worker processes run as user "nginx"
    And the nginx user has UID 32548 and belongs to group "nginx" with GID 32548
    And the nginx user has no login shell
