@domain:developer-tooling @area:support-scripts @from:1-25-2/ubuntu
Feature: Support notice and usage ping at boot
  Informs operators about project sponsorship and that each start reports use to the maintainer unless they opt out.

  Background:
    Given the nginx-lua Ubuntu 22.04 image for nginx 1.25.2

  @id:nginx.developer-tooling.support-scripts.004 @rule:runtime.support.boot-ping-opt-out @inferred @source:nginx/1.25.2/ubuntu/22.04/tpl/support.sh#support @questionable
  Scenario Outline: Each container start reports OS and nginx version unless SKIP_TRACK is 1
    Given SKIP_TRACK is <skip>
    When the operator starts the container
    Then the support banner is printed
    And <ping>

    Examples:
      | skip  | ping                                                                       |
      | unset | a request is sent to kodebeat.com carrying the OS id and the nginx version |
      | 1     | no outside request is made                                                 |
