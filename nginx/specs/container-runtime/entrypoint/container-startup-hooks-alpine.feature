@domain:container-runtime @area:entrypoint @from:1-31-2/alpine
Feature: Running startup hooks before nginx starts
  Operators drop scripts into the container's startup folder so configuration is prepared before nginx launches.

  Background:
    Given the nginx-lua Alpine image 1.31.2

  @id:nginx.container-runtime.entrypoint.283 @rule:container-runtime.entrypoint.runs-executable-hooks-in-version-order @inferred @source:nginx/1.31.2/alpine/3.24.1/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Executable startup scripts run in natural order before nginx starts
    Given the startup folder holds executable scripts 10-a.sh and 20-b.sh
    When the operator starts the container with the default nginx command
    Then 10-a.sh is launched before 20-b.sh
    And the log ends with "Configuration complete; ready for start up"
    And nginx then runs in the foreground
