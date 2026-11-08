@domain:container-runtime @area:entrypoint @from:1-21-3/amazonlinux
Feature: Container startup hooks
  Lets operators customise the container at start-up by dropping scripts into a directory, and control how chatty and how network-active the boot is.

  Background:
    Given Given the Amazon Linux nginx image

  @id:nginx.container-runtime.entrypoint.016 @rule:container-runtime.entrypoint.quiet-logs @inferred @source:nginx/1.21.3/amazonlinux/2.0.20211005.0/tpl/docker-entrypoint.sh#docker-entrypoint @questionable
  Scenario: Startup messages can be silenced
    Given NGINX_ENTRYPOINT_QUIET_LOGS is set to 1
    When the operator starts the container
    Then no "Launching" or "Configuration complete" lines appear in the log
    And startup scripts are still run

  @id:nginx.container-runtime.entrypoint.017 @rule:container-runtime.entrypoint.boot-tracking-opt-out @inferred @source:nginx/1.21.3/amazonlinux/2.0.20211005.0/tpl/support.sh#support @questionable
  Scenario: Each boot reports usage to the maintainer unless opted out
    Given SKIP_TRACK is not set to 1
    When the operator starts the container
    Then the support banner is printed
    And a request is sent to kodebeat.com within 5 seconds
