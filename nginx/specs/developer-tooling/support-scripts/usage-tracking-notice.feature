@domain:developer-tooling @area:support-scripts @from:1-25-1/ubuntu
Feature: Support banner and usage tracking at startup
  Informs operators the image reports usage on start and lets them opt out.

  Background:
    Given the nginx-lua 1.25.1 Ubuntu 22.04 image

  @id:nginx.developer-tooling.support-scripts.002 @rule:runtime.telemetry.boot-hit-unless-skipped @inferred @source:nginx/1.25.1/ubuntu/22.04/tpl/support.sh#SKIP_TRACK @questionable
  Scenario Outline: Starting the container shows a support banner and reports a boot hit unless opted out
    Given <skip_track>
    When the operator starts the container with the command nginx
    Then the logs show the "Support the Project" banner
    And <hit>

    Examples:
      | skip_track            | hit                                                                       |
      | SKIP_TRACK is not set | a request carrying the image OS and nginx version is sent to kodebeat.com |
      | SKIP_TRACK is 1       | no request is sent                                                        |
