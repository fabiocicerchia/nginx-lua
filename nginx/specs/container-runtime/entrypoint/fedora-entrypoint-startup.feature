@domain:container-runtime @area:entrypoint @from:1-31-6/fedora
Feature: Container start-up hooks
  Operators running the Fedora image get their configuration hooks executed in order before nginx starts, and a sponsorship banner at start.

  Background:
    Given Given the nginx-lua Fedora 44 image for nginx 1.31.6

  @id:nginx.container-runtime.entrypoint.311 @rule:container-runtime.entrypoint.hooks-run-in-version-order-before-nginx @inferred @source:nginx/1.31.6/fedora/44/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Start-up hooks run in version order before nginx launches
    Given the image's startup hook directory contains executable scripts 10-listen-on-ipv6-by-default.sh, 20-envsubst-on-templates.sh and 30-tune-worker-processes.sh
    When the operator starts the container with the default nginx command
    Then the scripts are launched in the order 10, 20, 30
    And the log ends with "Configuration complete; ready for start up"
    And nginx then replaces the entrypoint process as the main process

  @id:nginx.container-runtime.entrypoint.312 @rule:container-runtime.entrypoint.non-executable-hooks-are-skipped @inferred @source:nginx/1.31.6/fedora/44/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Hooks that are not executable are ignored with a notice
    Given the hook directory contains a script file without the executable bit
    When the operator starts the container with the default nginx command
    Then the log says "Ignoring <file>, not executable"
    And the script is not run
    And nginx still starts

  @id:nginx.container-runtime.entrypoint.313 @rule:container-runtime.entrypoint.hooks-skipped-for-other-commands @inferred @source:nginx/1.31.6/fedora/44/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Hooks are skipped when a command other than nginx is run
    Given the hook directory contains executable scripts
    When the operator starts the container with the command "sh"
    Then no startup hook runs
    And the command runs directly
