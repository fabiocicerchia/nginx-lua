@domain:container-runtime @area:entrypoint @from:1-29-5/amazonlinux
Feature: Container startup hooks
  Operators running the image get their startup scripts executed in a predictable order before nginx starts.

  @id:nginx.container-runtime.entrypoint.213 @rule:runtime.entrypoint.quiet-logs-opt-out @inferred @source:nginx/1.29.5/amazonlinux/2023.10.20260216.1/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Setting NGINX_ENTRYPOINT_QUIET_LOGS silences startup messages
    Given NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    When the operator starts the container with the nginx command
    Then no entrypoint messages are printed
    And nginx starts normally
