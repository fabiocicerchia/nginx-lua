@domain:container-runtime @area:entrypoint @from:1-29-0/alpine
Feature: Container startup hooks
  Lets operators of the Alpine nginx-lua image extend startup by dropping scripts in a directory that run before nginx launches, and reports a boot hit to the maintainer unless opted out.

  Background:
    Given the nginx-lua 1.29.0 image on Alpine 3.22

  @id:nginx.container-runtime.entrypoint.169 @rule:entrypoint.quiet-logs.suppresses-startup-messages @inferred @source:nginx/1.29.0/alpine/3.22.1/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Setting the quiet-logs variable silences startup script messages
    Given the container is configured with NGINX_ENTRYPOINT_QUIET_LOGS set to "1"
    When the operator starts the container
    Then the entrypoint and bundled startup scripts print no informational lines
    And the support banner is still printed
