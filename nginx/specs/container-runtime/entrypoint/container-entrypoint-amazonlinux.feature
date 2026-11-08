@domain:container-runtime @area:entrypoint @from:1-25-0/amazonlinux
Feature: Container startup hooks
  Lets operators customise nginx at container start by dropping scripts into the startup directory, then launches the requested command.

  Background:
    Given the nginx-lua image on Amazon Linux 2023

  @id:nginx.container-runtime.entrypoint.040 @rule:container-runtime.entrypoint.usage-ping-opt-out @inferred @source:nginx/1.25.0/amazonlinux/2023.0.20230503.0/tpl/support.sh#support @questionable
  Scenario: Each start reports a usage hit to the maintainer unless opted out
    Given SKIP_TRACK is not set to 1
    When the operator starts the container
    Then the support banner is printed
    And an HTTP hit with the OS name and nginx version is sent to kodebeat.com
