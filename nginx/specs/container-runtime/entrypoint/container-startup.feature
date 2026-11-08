@domain:container-runtime @area:entrypoint @from:1-29-1/debian
Feature: Container startup hooks
  Operators running the Debian 13 image get startup scripts executed before nginx launches, and can silence or opt out of the boot messages.

  Background:
    Given the nginx-lua Debian 13 image

  @id:nginx.container-runtime.entrypoint.174 @rule:container-runtime.entrypoint.hooks-run-in-order-before-nginx @inferred @source:nginx/1.29.1/debian/13.1/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Startup scripts run in version order before nginx starts
    Given the startup folder holds executable scripts 10-listen-on-ipv6-by-default.sh, 20-envsubst-on-templates.sh and 30-tune-worker-processes.sh
    When the operator starts the container with the default nginx command
    Then the log shows "Launching" for the 10, 20 and 30 scripts in that order
    And the log ends the hook phase with "Configuration complete; ready for start up"
    And nginx then runs in the foreground

  @id:nginx.container-runtime.entrypoint.175 @rule:container-runtime.entrypoint.non-nginx-command-skips-hooks @inferred @source:nginx/1.29.1/debian/13.1/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: A non-nginx command runs without any startup configuration
    When the operator starts the container with the command "sh"
    Then no startup script is launched
    And the command "sh" runs directly

  @id:nginx.container-runtime.entrypoint.177 @rule:container-runtime.entrypoint.quiet-logs-opt-out @inferred @source:nginx/1.29.1/debian/13.1/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Hook messages can be silenced
    Given the operator sets NGINX_ENTRYPOINT_QUIET_LOGS to 1
    When the operator starts the container with the default nginx command
    Then the startup hooks print no "Launching" or "Configuration complete" messages

  @id:nginx.container-runtime.entrypoint.178 @rule:container-runtime.entrypoint.boot-hit-reported-unless-skipped @inferred @source:nginx/1.29.1/debian/13.1/tpl/support.sh @questionable
  Scenario: Each boot reports an anonymous hit to the maintainer unless the operator opts out
    Given SKIP_TRACK is not set
    When the operator starts the container
    Then the log shows the "Support the Project" banner
    And a request carrying the OS id "debian" and nginx version "1.29.1" is sent to kodebeat.com with a 5 second limit
