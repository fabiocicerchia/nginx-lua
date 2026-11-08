@domain:developer-tooling @area:support-scripts @from:1-25-5/fedora
Feature: Start-up banner and usage tracking
  Informs operators about project support and reports boot statistics to the maintainer unless disabled.

  Background:
    Given the Fedora 40 image of nginx 1.25.5 with Lua support

  @id:nginx.developer-tooling.support-scripts.007 @rule:runtime.support.boot-hit-opt-out @inferred @source:nginx/1.25.5/fedora/40/tpl/support.sh @questionable
  Scenario Outline: Each start reports the OS and nginx version unless tracking is skipped
    Given SKIP_TRACK is <value>
    When the operator starts the container
    Then the sponsorship banner is printed
    And a request to the maintainer's stats service <sent>

    Examples:
      | value | sent                                |
      | unset | is sent with os=fedora and v=1.25.5 |
      | 0     | is sent with os=fedora and v=1.25.5 |
      | 1     | is not sent                         |
