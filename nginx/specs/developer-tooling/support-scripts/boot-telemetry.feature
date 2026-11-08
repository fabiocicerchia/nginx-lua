@domain:developer-tooling @area:support-scripts @from:1-25-5/almalinux
Feature: Boot usage reporting
  Informs operators the container reports usage on boot and lets them opt out.

  Background:
    Given the AlmaLinux 9.4 nginx-lua image for nginx 1.25.5

  @id:nginx.developer-tooling.support-scripts.006 @rule:runtime.telemetry.boot-ping-opt-out @inferred @source:nginx/1.25.5/almalinux/9.4-20240506/tpl/support.sh @questionable
  Scenario: Each boot reports the OS and nginx version unless opted out
    Given SKIP_TRACK is not set to 1
    When the operator starts the container
    Then a request with os=almalinux and v=1.25.5 is sent to kodebeat.com
    And a sponsorship message is printed
