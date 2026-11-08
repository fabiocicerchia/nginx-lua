@domain:container-startup @area:entrypoint-flow @from:src/docker-entrypoint
Feature: Starting the container
  Operators running the nginx-lua image get their startup scripts run in order before nginx (or another command) is launched.

  @id:src.container-startup.entrypoint-flow.001 @rule:container-startup.entrypoint-flow.scripts-run-before-nginx @inferred @source:src/docker-entrypoint.sh#entrypoint_log
  Scenario: Executable startup scripts run in version order before nginx starts
    Given the startup directory contains the executable scripts "10-first.sh" and "20-second.sh"
    When the operator starts the container with the command "nginx"
    Then "10-first.sh" is launched before "20-second.sh"
    And the log shows "Configuration complete; ready for start up"
    And nginx is then started as the container's main process

  @id:src.container-startup.entrypoint-flow.002 @rule:container-startup.entrypoint-flow.non-executable-scripts-ignored @inferred @source:src/docker-entrypoint.sh#entrypoint_log
  Scenario: Startup scripts without execute permission are skipped
    Given the startup directory contains a script that is not executable
    When the operator starts the container with the command "nginx"
    Then the log shows "Ignoring" followed by the script path and "not executable"
    And the script is not run
    And nginx is still started

  @id:src.container-startup.entrypoint-flow.003 @rule:container-startup.entrypoint-flow.environment-scripts-sourced @inferred @source:src/docker-entrypoint.sh#entrypoint_log @questionable
  Scenario: Executable environment scripts are sourced so their variables reach later startup steps
    Given the startup directory contains an executable environment script "15-vars" that exports a variable
    When the operator starts the container with the command "nginx"
    Then the log shows "Sourcing" followed by the script path
    And later startup scripts see the exported variable

  @id:src.container-startup.entrypoint-flow.004 @rule:container-startup.entrypoint-flow.empty-directory-skips-configuration @inferred @source:src/docker-entrypoint.sh#entrypoint_log
  Scenario: An empty startup directory skips configuration
    Given the startup directory contains no files
    When the operator starts the container with the command "nginx"
    Then the log shows "No files found in /docker-entrypoint.d/, skipping configuration"
    And nginx is started

  @id:src.container-startup.entrypoint-flow.005 @rule:container-startup.entrypoint-flow.other-commands-bypass-scripts @inferred @source:src/docker-entrypoint.sh#entrypoint_log
  Scenario: Other commands run directly without startup scripts
    Given the startup directory contains executable scripts
    When the operator starts the container with the command "sh"
    Then no startup script is launched
    And the command "sh" is run as the container's main process
