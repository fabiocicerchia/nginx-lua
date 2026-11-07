@domain:container-startup @area:default-config @from:1-19-10/debian
Feature: Default configuration
  Gives operators a container that serves HTTP with sensible defaults as soon as it runs with no arguments.

  Background:
    Given the operator has not supplied any configuration of their own

  @id:nginx.container-startup.default-config.030 @rule:container.defaults.runs-nginx-in-foreground @inferred @source:nginx/1.19.10/debian/10.9/Dockerfile#CMD
  Scenario: With no command given, the container runs nginx in the foreground
    When the operator starts the container without a command
    Then the main process is "nginx -g 'daemon off;'"
    And the container keeps running until nginx stops

  @id:nginx.container-startup.default-config.031 @rule:container.defaults.workers-run-as-nginx-user @inferred @source:nginx/1.19.10/debian/10.9/tpl/nginx.conf#user
  Scenario: nginx worker processes run as the unprivileged nginx user
    When the operator starts the container without a command
    Then the worker processes run as user "nginx" with uid 101 and group "nginx" with gid 101
    And the nginx user cannot log in

  @id:nginx.container-startup.default-config.032 @rule:container.defaults.default-site-on-port-80 @inferred @source:nginx/1.19.10/debian/10.9/tpl/default.conf#server @questionable
  Scenario: The default site on port 80 has no content to serve
    When a client requests http://localhost/ from the running container
    Then the default site for server name "localhost" answers on port 80
    And the response status is 404 because /usr/share/nginx/html is not in the image
