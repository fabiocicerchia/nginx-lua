@domain:container-startup @area:startup-logging @from:src/docker-entrypoint
Feature: Quieting startup logs
  Operators can silence the entrypoint's progress messages to keep container logs clean.

  @id:src.container-startup.startup-logging.001 @rule:container-startup.startup-logging.quiet-logs @inferred @source:src/docker-entrypoint.sh#entrypoint_log
  Scenario: Setting the quiet option silences entrypoint messages
    Given the startup directory contains an executable script
    And the operator has set NGINX_ENTRYPOINT_QUIET_LOGS to "1"
    When the operator starts the container with the command "nginx"
    Then the entrypoint's startup progress messages are not printed, though the project support banner still is
    And the script is still launched
    And nginx is started
