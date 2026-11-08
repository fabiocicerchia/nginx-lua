@domain:container-runtime @area:entrypoint @from:1-28-1/debian
Feature: Running startup hooks before nginx
  Lets operators customise container start-up by dropping scripts into a directory that run before nginx launches.

  Background:
    Given Given the nginx-lua Debian image is started

  @id:nginx.container-runtime.entrypoint.155 @rule:runtime.entrypoint.quiet-logs-silence-hook-messages @inferred @source:nginx/1.28.1/debian/13.3/tpl/docker-entrypoint.sh#entrypoint_log @questionable
  Scenario: Quiet mode silences start-up messages
    Given NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    When the operator starts the container with the default nginx command
    Then the entrypoint prints no "Launching" or "Configuration complete" lines
