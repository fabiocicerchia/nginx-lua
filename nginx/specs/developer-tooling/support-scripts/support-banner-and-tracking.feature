@domain:developer-tooling @area:support-scripts @from:1-21-3/alpine
Feature: Start-up banner and usage tracking
  Tells operators about project sponsorship and reports a boot hit to the maintainer unless opted out.

  Background:
    Given the image is started with its default entrypoint

  @id:nginx.developer-tooling.support-scripts.001 @rule:container-runtime.support.boot-hit-opt-out @inferred @source:nginx/1.21.3/alpine/3.14.2/tpl/support.sh#support @questionable
  Scenario Outline: A boot hit is sent to the maintainer's server unless tracking is skipped
    Given the environment variable SKIP_TRACK is <value>
    When the operator starts the container
    Then the sponsorship banner is printed
    And a request to kodebeat.com is <sent>

    Examples:
      | value | sent      |
      | unset | attempted |
      | 0     | attempted |
      | 1     | not made  |
