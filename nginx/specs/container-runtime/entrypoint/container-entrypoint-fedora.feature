@domain:container-runtime @area:entrypoint @from:1-25-5/fedora
Feature: Container startup hooks
  Lets operators customise the container at start-up through scripts in /docker-entrypoint.d before nginx is launched.

  Background:
    Given the Fedora 40 image of nginx 1.25.5 with Lua support

  @id:nginx.container-runtime.entrypoint.095 @rule:runtime.entrypoint.hooks-run-before-nginx @inferred @source:nginx/1.25.5/fedora/40/tpl/docker-entrypoint.sh
  Scenario: Executable startup scripts run in version order before nginx starts
    Given the startup directory contains the executable scripts 10-a.sh and 20-b.sh
    When the operator starts the container with the default nginx command
    Then 10-a.sh is launched before 20-b.sh
    And the log shows "Configuration complete; ready for start up"
    And nginx then replaces the entrypoint process

  @id:nginx.container-runtime.entrypoint.096 @rule:runtime.entrypoint.non-runnable-files-ignored @inferred @source:nginx/1.25.5/fedora/40/tpl/docker-entrypoint.sh
  Scenario Outline: Non-executable or unrecognised startup files are skipped with a notice
    Given the startup directory contains <file> with <mode>
    When the operator starts the container with the default nginx command
    Then the log shows "<message>"
    And the file is not run

    Examples:
      | file       | mode           | message                                               |
      | 30-x.sh    | no execute bit | Ignoring /docker-entrypoint.d/30-x.sh, not executable |
      | README.txt | any            | Ignoring /docker-entrypoint.d/README.txt              |
