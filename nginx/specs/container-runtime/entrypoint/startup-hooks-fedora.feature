@domain:container-runtime @area:entrypoint @from:1-29-4/fedora
Feature: Running startup scripts before nginx starts
  Lets operators customise a container at boot by dropping scripts into /docker-entrypoint.d/ and have them run before nginx launches.

  Background:
    Given Given the nginx-lua Fedora 43 image for nginx 1.29.4

  @id:nginx.container-runtime.entrypoint.206 @rule:runtime.entrypoint.quiet-logs-silence-startup-messages @inferred @source:nginx/1.29.4/fedora/43/tpl/docker-entrypoint.sh#entrypoint_log @questionable
  Scenario: Quiet mode silences startup messages
    Given the environment variable NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    And the folder /docker-entrypoint.d/ contains an executable 15-custom.sh
    When the operator starts the container with the default nginx command
    Then the entrypoint prints no "Launching" or "Configuration complete" lines
    And 15-custom.sh still runs
