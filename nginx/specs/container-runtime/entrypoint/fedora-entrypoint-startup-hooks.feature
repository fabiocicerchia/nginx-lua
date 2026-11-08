@domain:container-runtime @area:entrypoint @from:1-30-4/fedora
Feature: Container startup hooks
  Operators running the Fedora 44 image get configuration scripts executed in a predictable order before nginx starts.

  Background:
    Given the nginx 1.30.4 Fedora 44 image

  @id:nginx.container-runtime.entrypoint.249 @rule:container-runtime.entrypoint.quiet-logs-silences-hooks @inferred @source:nginx/1.30.4/fedora/44/tpl/docker-entrypoint.sh#entrypoint_log @questionable
  Scenario: Quiet mode suppresses the entrypoint's log lines
    Given the container has NGINX_ENTRYPOINT_QUIET_LOGS set to 1
    When the operator starts the container with the default nginx command
    Then the entrypoint prints no "Launching" or "Configuration complete" lines
