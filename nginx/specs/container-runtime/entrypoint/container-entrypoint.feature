@domain:container-runtime @area:entrypoint @from:1-21-1/fedora
Feature: Container startup hooks
  Lets an operator customise a container at start-up by dropping scripts into the hook directory, then launches nginx.

  Background:
    Given the nginx-lua image for nginx 1.21.1 on Fedora 34

  @id:nginx.container-runtime.entrypoint.005 @rule:runtime.entrypoint.runs-executable-hooks-before-nginx @inferred @source:nginx/1.21.1/fedora/34/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Executable startup scripts run before nginx starts
    Given the hook directory holds executable scripts 10-listen-on-ipv6-by-default.sh and 20-envsubst-on-templates.sh
    When the operator starts the container with the default nginx command
    Then the log shows "Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh" before "Launching /docker-entrypoint.d/20-envsubst-on-templates.sh"
    And the log shows "Configuration complete; ready for start up"
    And nginx then runs in the foreground

  @id:nginx.container-runtime.entrypoint.006 @rule:runtime.entrypoint.skips-non-runnable-hook-files @inferred @source:nginx/1.21.1/fedora/34/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario Outline: Hook files that are not executable shell scripts are ignored with a notice
    Given the hook directory holds <file>
    When the operator starts the container with the default nginx command
    Then the log shows "<message>"
    And the file is not run
    And nginx still starts

    Examples:
      | file                          | message                                                    |
      | a non-executable 30-custom.sh | Ignoring /docker-entrypoint.d/30-custom.sh, not executable |
      | a file notes.txt              | Ignoring /docker-entrypoint.d/notes.txt                    |

  @id:nginx.container-runtime.entrypoint.007 @rule:runtime.entrypoint.hooks-only-for-nginx-command @inferred @source:nginx/1.21.1/fedora/34/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Startup hooks are skipped when the container runs another command
    Given the hook directory holds executable scripts
    When the operator starts the container with the command "sh"
    Then no hook is launched
    And the command runs directly

  @id:nginx.container-runtime.entrypoint.008 @rule:runtime.entrypoint.quiet-logs-option @inferred @source:nginx/1.21.1/fedora/34/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Startup messages can be silenced
    Given the environment variable NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    When the operator starts the container with the default nginx command
    Then no start-up messages from the entrypoint or hooks appear in the log
    And the hooks still run
