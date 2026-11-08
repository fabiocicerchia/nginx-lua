@domain:container-runtime @area:entrypoint @from:1-23-3/almalinux
Feature: Container startup hooks
  Lets operators rely on configuration scripts running before nginx starts, and on other commands bypassing them.

  Background:
    Given Given an AlmaLinux 8.7 nginx-lua image

  @id:nginx.container-runtime.entrypoint.024 @rule:container-runtime.entrypoint.hooks-run-before-nginx @inferred @source:nginx/1.23.3/almalinux/8.7-20221201/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Startup scripts run in version order before nginx starts
    Given the image ships startup scripts 10-listen-on-ipv6-by-default.sh, 20-envsubst-on-templates.sh and 30-tune-worker-processes.sh
    When the operator starts a container with the default command
    Then each script is launched in order 10, 20, 30 and logged as "Launching"
    And the log ends with "Configuration complete; ready for start up"
    And nginx then runs as the container's main process

  @id:nginx.container-runtime.entrypoint.025 @rule:container-runtime.entrypoint.non-nginx-commands-skip-hooks @inferred @source:nginx/1.23.3/almalinux/8.7-20221201/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Running another command skips the startup scripts
    Given no special environment
    When the operator starts a container with the command "sh"
    Then no startup script is launched
    And the command runs directly

  @id:nginx.container-runtime.entrypoint.026 @rule:container-runtime.entrypoint.non-executable-scripts-ignored @inferred @source:nginx/1.23.3/almalinux/8.7-20221201/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: A startup script without execute permission is ignored with a notice
    Given a script 40-custom.sh without the execute bit is mounted in the hooks directory
    When the operator starts a container with the default command
    Then the log shows "Ignoring /docker-entrypoint.d/40-custom.sh, not executable"
    And nginx still starts

  @id:nginx.container-runtime.entrypoint.028 @rule:container-runtime.entrypoint.boot-usage-ping-opt-out @inferred @source:nginx/1.23.3/almalinux/8.7-20221201/tpl/support.sh#support @questionable
  Scenario Outline: Each boot reports usage to the maintainer unless SKIP_TRACK is 1
    Given SKIP_TRACK is not set to 1
    When the operator starts a container
    Then a support banner is printed
    And a request carrying the OS name and nginx version is sent to the maintainer's tracking site, with a 5 second limit

    Examples:
      | SKIP_TRACK | tracking request sent |
      | (unset)    | yes                   |
      | 0          | yes                   |
      | 1          | no                    |
