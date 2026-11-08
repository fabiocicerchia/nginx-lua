@domain:container-runtime @area:entrypoint @from:1-31-4/alpine
Feature: Container startup hooks
  Lets operators customise the container at start by dropping scripts into a hook directory, before nginx is launched.

  @id:nginx.container-runtime.entrypoint.291 @rule:container-runtime.entrypoint.runs-hooks-in-version-order @inferred @source:nginx/1.31.4/alpine/3.24.1/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Startup scripts run in natural version order before nginx starts
    Given the hook directory contains executable scripts 10-a.sh and 9-b.sh
    When the operator starts the container with the default nginx command
    Then 9-b.sh runs before 10-a.sh
    And the log shows "Launching /docker-entrypoint.d/9-b.sh" then "Launching /docker-entrypoint.d/10-a.sh"
    And the log shows "Configuration complete; ready for start up"
    And nginx then runs in the foreground

  @id:nginx.container-runtime.entrypoint.292 @rule:container-runtime.entrypoint.skips-non-executable-hooks @inferred @source:nginx/1.31.4/alpine/3.24.1/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Hook scripts without execute permission are ignored with a notice
    Given the hook directory contains a script 40-custom.sh without execute permission
    When the operator starts the container with the default nginx command
    Then the log shows "Ignoring /docker-entrypoint.d/40-custom.sh, not executable"
    And 40-custom.sh is not run
    And nginx still starts
