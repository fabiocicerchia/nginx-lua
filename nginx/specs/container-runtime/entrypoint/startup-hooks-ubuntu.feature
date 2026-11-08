@domain:container-runtime @area:entrypoint @from:1-30-5/ubuntu
Feature: Running startup hooks before nginx starts
  Lets operators drop scripts into the image's startup directory so configuration is prepared each time the container starts nginx.

  Background:
    Given Given the container image's default command starts nginx

  @id:nginx.container-runtime.entrypoint.258 @rule:container-runtime.entrypoint.quiet-logs-silences-startup-messages @inferred @source:nginx/1.30.5/ubuntu/26.04/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Quiet mode silences startup messages
    Given NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    When the operator starts the container with the default nginx command
    Then the entrypoint prints no "Launching", "Ignoring" or "Configuration complete" lines
    And nginx starts
