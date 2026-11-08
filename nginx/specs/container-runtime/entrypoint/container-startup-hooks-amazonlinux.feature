@domain:container-runtime @area:entrypoint @from:1-27-5/amazonlinux
Feature: Container startup hooks
  Lets operators customise the container at start-up with hook scripts and keep logs quiet, while nginx still launches.

  Background:
    Given the amazonlinux nginx-lua image

  @id:nginx.container-runtime.entrypoint.142 @rule:container.entrypoint.hooks-run-only-for-nginx @inferred @source:nginx/1.27.5/amazonlinux/2023.7.20250609.0/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Startup hooks run in version order only when the container starts nginx
    Given the image contains executable hooks 10-listen-on-ipv6-by-default.sh, 20-envsubst-on-templates.sh and 30-tune-worker-processes.sh
    When the operator starts the container with the default nginx command
    Then the hooks run in the order 10, 20, 30
    And the log shows "Configuration complete; ready for start up"
    And nginx then replaces the entrypoint process

  @id:nginx.container-runtime.entrypoint.143 @rule:container.entrypoint.skips-non-executable-hooks @inferred @source:nginx/1.27.5/amazonlinux/2023.7.20250609.0/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: A hook without execute permission is skipped with a warning
    Given a hook script in the hooks directory lacks the execute bit
    When the operator starts the container with the default nginx command
    Then the log shows "Ignoring" followed by the hook path, "not executable"
    And the remaining hooks still run
    And nginx starts

  @id:nginx.container-runtime.entrypoint.145 @rule:container.entrypoint.usage-beacon-on-boot @inferred @source:nginx/1.27.5/amazonlinux/2023.7.20250609.0/tpl/support.sh @questionable
  Scenario: Every container start sends a usage ping to the maintainer unless opted out
    Given SKIP_TRACK is not set to 1
    When the operator starts the container
    Then a banner asking for sponsorship is printed
    And a request carrying the OS id and nginx version is sent to kodebeat.com with a 5 second limit
