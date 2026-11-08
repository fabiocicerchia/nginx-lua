@domain:container-runtime @area:entrypoint @from:1-21-3/alpine
Feature: Container startup hooks
  Lets an operator customise the container at start-up by dropping scripts into a hooks directory, while keeping nginx as the main process.

  Background:
    Given The image is started with its default entrypoint

  @id:nginx.container-runtime.entrypoint.009 @rule:container-runtime.entrypoint.runs-executable-hooks-in-order @inferred @source:nginx/1.21.3/alpine/3.14.2/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Executable startup scripts run in order before nginx starts
    Given the hooks directory contains an executable 10-first.sh and an executable 20-second.sh
    And the container command is nginx
    When the operator starts the container
    Then 10-first.sh runs before 20-second.sh
    And the log shows "Launching /docker-entrypoint.d/10-first.sh" then "Launching /docker-entrypoint.d/20-second.sh"
    And the log shows "Configuration complete; ready for start up"
    And nginx then runs in the foreground

  @id:nginx.container-runtime.entrypoint.010 @rule:container-runtime.entrypoint.skips-non-runnable-files @inferred @source:nginx/1.21.3/alpine/3.14.2/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario Outline: Hook files that are not executable shell scripts are ignored with a notice
    Given the hooks directory contains <file>
    When the operator starts the container
    Then the log shows "<message>"
    And the file is not run

    Examples:
      | file                      | message                                                |
      | a non-executable setup.sh | Ignoring /docker-entrypoint.d/setup.sh, not executable |
      | an executable notes.txt   | Ignoring /docker-entrypoint.d/notes.txt                |

  @id:nginx.container-runtime.entrypoint.011 @rule:container-runtime.entrypoint.hooks-only-for-nginx-command @inferred @source:nginx/1.21.3/alpine/3.14.2/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Startup hooks run only when the container command is nginx
    Given the hooks directory contains an executable 10-first.sh
    When the operator starts the container with the command "sh"
    Then no hook is launched
    And the command sh runs directly

  @id:nginx.container-runtime.entrypoint.012 @rule:container-runtime.entrypoint.quiet-logs-option @inferred @source:nginx/1.21.3/alpine/3.14.2/tpl/docker-entrypoint.sh#docker-entrypoint @questionable
  Scenario: Quiet mode silences start-up messages
    Given the environment variable NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    And the hooks directory contains an executable 10-first.sh
    When the operator starts the container
    Then the hook still runs
    And no "Launching" or "Configuration complete" message is logged
