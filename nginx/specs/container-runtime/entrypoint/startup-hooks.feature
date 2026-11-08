@domain:container-runtime @area:entrypoint @from:1-19-3/amazonlinux
Feature: Container startup hooks
  Lets an operator customise the container at start by dropping scripts into a directory before nginx launches.

  Background:
    Given Given the nginx 1.19.3 Amazon Linux 2.0.20200722.0 image

  @id:nginx.container-runtime.entrypoint.001 @rule:entrypoint.startup-hooks.executable-scripts-run-before-nginx @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Executable startup scripts run before nginx starts
    Given the startup directory holds an executable script 30-warmup.sh
    When the operator starts the container with the default nginx command
    Then the log shows "Launching /docker-entrypoint.d/30-warmup.sh"
    And the log shows "Configuration complete; ready for start up"
    And nginx then runs in the foreground

  @id:nginx.container-runtime.entrypoint.002 @rule:entrypoint.startup-hooks.non-runnable-files-ignored @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario Outline: Files that are not executable shell scripts are skipped with a notice
    Given the startup directory holds <file>
    When the operator starts the container with the default nginx command
    Then the log shows "<message>"
    And the file is not executed
    And nginx still starts

    Examples:
      | file                         | message                                                   |
      | a non-executable 40-notes.sh | Ignoring /docker-entrypoint.d/40-notes.sh, not executable |
      | a file README.txt            | Ignoring /docker-entrypoint.d/README.txt                  |

  @id:nginx.container-runtime.entrypoint.003 @rule:entrypoint.startup-hooks.skipped-for-other-commands @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Startup scripts are not run when a command other than nginx is given
    Given the startup directory holds the default scripts
    When the operator starts the container with the command "sh"
    Then no startup script is launched
    And the shell runs directly

  @id:nginx.container-runtime.entrypoint.004 @rule:entrypoint.startup-hooks.quiet-logs-switch @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Setting NGINX_ENTRYPOINT_QUIET_LOGS silences startup messages
    Given NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    When the operator starts the container with the default nginx command
    Then no entrypoint messages appear in the container log
    And the startup scripts still run
