@domain:developer-tooling @area:support-scripts @from:1-29-2/debian
Feature: Start-up support notice and usage ping
  Tells operators about project sponsorship and discloses an anonymous boot ping they can switch off.

  Background:
    Given the nginx-lua 1.29.2 Debian 13.1 image

  @id:nginx.developer-tooling.support-scripts.008 @rule:container-runtime.entrypoint.boot-ping-opt-out @inferred @source:nginx/1.29.2/debian/13.1/tpl/support.sh#support @questionable
  Scenario Outline: Each start prints the sponsorship notice and reports a boot hit unless opted out
    Given SKIP_TRACK is <value>
    When the container starts
    Then the log shows the "Support the Project" notice
    And a request carrying the OS id and nginx version is <ping>

    Examples:
      | value   | ping                                         |
      | not set | sent to kodebeat.com with a 5-second timeout |
      | "1"     | not sent                                     |
