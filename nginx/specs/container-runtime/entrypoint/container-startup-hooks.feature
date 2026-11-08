@domain:container-runtime @area:entrypoint @from:1-23-3/ubuntu
Feature: Container startup hooks
  Lets operators run their own scripts before nginx starts, by dropping them into the startup directory.

  Background:
    Given the nginx 1.23.3 Ubuntu 22.04 image

  @id:nginx.container-runtime.entrypoint.031 @rule:runtime.entrypoint.quiet-logs-switch @inferred @source:nginx/1.23.3/ubuntu/22.04/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Setting the quiet switch silences startup messages
    Given the environment variable NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    When the operator starts the container with the command nginx
    Then the entrypoint and bundled hooks print no configuration progress messages
    And the support banner is still printed
