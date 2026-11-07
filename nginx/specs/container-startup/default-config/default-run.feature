@domain:container-startup @area:default-config @from:1-19-4/alpine
Feature: Default run behaviour
  Gives operators an image that serves on port 80 out of the box with nginx in the foreground and workers dropped to a fixed unprivileged user.

  Background:
    Given the nginx-lua 1.19.4 Alpine 3.12.1 image

  @id:nginx.container-startup.default-config.048 @rule:container.default-config.foreground-default-command @inferred @source:nginx/1.19.4/alpine/3.12.1/Dockerfile#CMD
  Scenario: With no command given, nginx runs in the foreground as the container process
    Given no command override
    When the operator starts the container
    Then nginx runs with "-g 'daemon off;'"
    And the container stays up while nginx runs
    And GET http://localhost/ returns 200 with the stock nginx welcome page

  @id:nginx.container-startup.default-config.049 @rule:container.default-config.conf-d-not-loaded @inferred @source:nginx/1.19.4/alpine/3.12.1/Dockerfile#NGINX_BUILD_CONFIG @questionable
  Scenario: Files placed in conf.d are not loaded by the shipped configuration
    Given /etc/nginx/conf.d/app.conf defines a server for "app.example.com" on port 80
    And the shipped /etc/nginx/nginx.conf is in use
    When the operator starts the container
    Then a request for "app.example.com" is answered by the stock default server
    And nginx starts

  @id:nginx.container-startup.default-config.050 @rule:container.default-config.nginx-user-101 @inferred @source:nginx/1.19.4/alpine/3.12.1/Dockerfile#RUN
  Scenario: Workers run as the nginx user with uid and gid 101
    Given the default configuration
    When the operator starts the container
    Then nginx worker processes run as user "nginx" with uid 101 and gid 101
    And the nginx user has no login shell
