@domain:container-runtime @area:entrypoint @from:1-29-2/alpine
Feature: Container startup hooks
  Operators running the Alpine image rely on startup hooks to configure nginx before it serves traffic, and on clear controls over logging and usage reporting.

  Background:
    Given Given the nginx-lua image based on Alpine 3.22.2 (the 3.22.1 image ships identical scripts)

  @id:nginx.container-runtime.entrypoint.180 @rule:startup.entrypoint.runs-hooks-in-version-order @inferred @source:nginx/1.29.2/alpine/3.22.2/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Executable startup hooks run in version order before nginx starts
    Given the container starts with the command "nginx -g 'daemon off;'"
    And /docker-entrypoint.d holds executable scripts 10-listen-on-ipv6-by-default.sh, 20-envsubst-on-templates.sh and 30-tune-worker-processes.sh
    When the operator starts the container
    Then the log shows "Launching" for 10-, then 20-, then 30- in that order
    And the log ends with "Configuration complete; ready for start up"
    And nginx then replaces the entrypoint as the main process

  @id:nginx.container-runtime.entrypoint.181 @rule:startup.entrypoint.skips-unusable-hooks @inferred @source:nginx/1.29.2/alpine/3.22.2/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario Outline: Hooks without execute permission or other commands are not run
    Given /docker-entrypoint.d holds a non-executable script custom.sh
    When the operator starts the container with <command>
    Then <outcome>

    Examples:
      | command | outcome                                                                                          |
      | nginx   | the log says "Ignoring /docker-entrypoint.d/custom.sh, not executable" and the script is not run |
      | sh      | no hooks are looked up and the shell starts immediately                                          |

  @id:nginx.container-runtime.entrypoint.182 @rule:startup.entrypoint.quiet-logs @inferred @source:nginx/1.29.2/alpine/3.22.2/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Quiet mode silences startup messages
    Given NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    When the operator starts the container with the nginx command
    Then no "Launching" or "Configuration complete" lines appear in the log

  @id:nginx.container-runtime.entrypoint.183 @rule:startup.entrypoint.usage-reporting-opt-out @inferred @source:nginx/1.29.2/alpine/3.22.2/tpl/support.sh @questionable
  Scenario: Each start reports the OS and nginx version to the maintainer unless opted out
    Given SKIP_TRACK is not set to 1
    When the operator starts the container
    Then a sponsorship banner is printed
    And the container calls https://kodebeat.com/nginx-lua/stats/hit/boot.php with the OS id and nginx version
