@domain:container-runtime @area:entrypoint @from:1-31-7/debian
Feature: Container startup hooks
  Lets operators prepare nginx configuration at container start by dropping scripts into the startup directory.

  Background:
    Given the nginx-lua Debian 13.7 image

  @id:nginx.container-runtime.entrypoint.319 @rule:container-runtime.entrypoint.quiet-logs-and-non-nginx-commands @inferred @source:nginx/1.31.7/debian/13.7/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Startup hooks are skipped for other commands and the logs can be silenced
    Given the container is started with a command other than nginx or nginx-debug, or NGINX_ENTRYPOINT_QUIET_LOGS is set
    When the operator starts the container
    Then no startup scripts run when the command is not nginx or nginx-debug
    And no entrypoint messages are printed when NGINX_ENTRYPOINT_QUIET_LOGS is non-empty
