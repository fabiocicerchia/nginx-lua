@domain:container-runtime @area:entrypoint @from:1-29-6/almalinux
Feature: Running startup hooks before nginx
  Serves operators who drop scripts into /docker-entrypoint.d/ and need them to run predictably before nginx starts.

  Background:
    Given Given the almalinux 1.29.6 image is started by the operator

  @id:nginx.container-runtime.entrypoint.215 @rule:container.entrypoint.quiet-logs-suppresses-hook-messages @inferred @source:nginx/1.29.6/almalinux/10.1-20260129/tpl/docker-entrypoint.sh#entrypoint_log @questionable
  Scenario: Quiet mode silences the entrypoint's own messages
    Given NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    When the operator starts the container with the default nginx command
    Then no "Launching" or "Configuration complete" lines are written by the entrypoint
