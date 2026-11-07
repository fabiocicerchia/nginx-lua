@domain:web-server @area:debug-binary @from:1-19-3/ubuntu
Feature: Debug nginx binary
  Gives operators a debug-enabled nginx alongside the release binary for verbose troubleshooting.

  @id:nginx.web-server.debug-binary.002 @rule:container.debug.nginx-debug-available @inferred @source:nginx/1.19.3/ubuntu/20.04/tpl/Makefile#core
  Scenario: A debug-enabled nginx can be run instead of the release binary
    Given the operator's config sets "error_log /dev/stderr debug;"
    When the operator starts the container with the command "nginx-debug -g 'daemon off;'"
    Then startup hooks run as for nginx
    And debug-level messages appear on standard error
    And "nginx-debug -V" lists "--with-debug"
