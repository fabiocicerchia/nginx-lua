@domain:container-startup @area:default-config @from:1-19-3/ubuntu
Feature: Default runtime configuration
  What an operator gets from the Ubuntu nginx 1.19.3 image with no customisation: nginx in the foreground, an unprivileged worker user and timezone support.

  Background:
    Given Given the operator uses the nginx 1.19.3 Ubuntu 20.04 image

  @id:nginx.container-startup.default-config.045 @rule:container.defaults.nginx-foreground @inferred @source:nginx/1.19.3/ubuntu/20.04/Dockerfile#CMD
  Scenario: A container started without arguments runs nginx in the foreground and serves port 80
    Given no command is given
    When the operator starts the container with port 80 published
    Then nginx runs in the foreground as the container's main process
    And a request to http://localhost/ answers 200 with the nginx welcome page

  @id:nginx.container-startup.default-config.046 @rule:container.defaults.unprivileged-nginx-user @inferred @source:nginx/1.19.3/ubuntu/20.04/Dockerfile#RUN
  Scenario: nginx workers run as the unprivileged nginx user with id 101
    Given no user directive is set in the config
    When the operator starts the container
    Then nginx worker processes run as user "nginx" (uid 101) and group "nginx" (gid 101)
    And the nginx user has no login shell and no home directory
