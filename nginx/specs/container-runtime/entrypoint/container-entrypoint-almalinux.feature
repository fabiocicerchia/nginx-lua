@domain:container-runtime @area:entrypoint @from:1-25-2/almalinux
Feature: Container startup hooks
  Lets operators customise container start-up by dropping scripts into a hooks directory that run before nginx launches.

  Background:
    Given the AlmaLinux 9.2 nginx 1.25.2 image

  @id:nginx.container-runtime.entrypoint.057 @rule:container-runtime.entrypoint.hooks-run-in-version-order @inferred @source:nginx/1.25.2/almalinux/9.2-20230718/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Executable startup scripts run in natural order before nginx starts
    Given the hooks directory holds executable scripts 10-a.sh, 20-b.sh and 100-c.sh
    When the operator starts the container with the default nginx command
    Then the log shows "Launching /docker-entrypoint.d/10-a.sh", then 20-b.sh, then 100-c.sh
    And the log shows "Configuration complete; ready for start up"
    And nginx then runs in the foreground as the main process

  @id:nginx.container-runtime.entrypoint.058 @rule:container-runtime.entrypoint.non-executable-hooks-ignored @inferred @source:nginx/1.25.2/almalinux/9.2-20230718/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario Outline: Each hook file is logged according to its type and execute permission
    Given the hooks directory holds <file>
    When the operator starts the container with the default nginx command
    Then the log shows "<message>"

    Examples:
      | file                        | message                                               |
      | 30-x.sh without execute bit | Ignoring /docker-entrypoint.d/30-x.sh, not executable |
      | readme.txt                  | Ignoring /docker-entrypoint.d/readme.txt              |
      | env.envsh executable        | Sourcing /docker-entrypoint.d/env.envsh               |

  @id:nginx.container-runtime.entrypoint.059 @rule:container-runtime.entrypoint.hooks-only-for-nginx @inferred @source:nginx/1.25.2/almalinux/9.2-20230718/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Other commands skip configuration and run directly
    Given the hooks directory holds executable scripts
    When the operator starts the container with the command "sh"
    Then no hook is launched
    And the shell runs as the main process
