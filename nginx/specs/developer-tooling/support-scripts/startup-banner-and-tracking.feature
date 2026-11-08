@domain:developer-tooling @area:support-scripts @from:1-25-2/almalinux
Feature: Startup banner and usage tracking
  Informs operators of the sponsorship request and the anonymous boot ping, and lets them opt out.

  Background:
    Given Given the AlmaLinux 9.2 nginx 1.25.2 image

  @id:nginx.developer-tooling.support-scripts.003 @rule:developer-tooling.support-scripts.boot-ping-opt-out @inferred @source:nginx/1.25.2/almalinux/9.2-20230718/tpl/support.sh#support @questionable
  Scenario Outline: Each start reports the OS and nginx version to an external service unless opted out
    Given SKIP_TRACK is <skip>
    When the operator starts the container
    Then the log shows the "Support the Project" banner
    And <ping>

    Examples:
      | skip  | ping                                                             |
      | unset | a request is sent to kodebeat.com with os=almalinux and v=1.25.2 |
      | 1     | no request is sent                                               |
