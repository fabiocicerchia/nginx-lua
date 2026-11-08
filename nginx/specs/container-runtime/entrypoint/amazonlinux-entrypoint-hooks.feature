@domain:container-runtime @area:entrypoint @from:1-27-2/amazonlinux
Feature: Starting the Amazon Linux container runs startup hooks before nginx
  Operators running the Amazon Linux image get startup hooks executed in order before nginx launches, with clear log output.

  Background:
    Given the nginx-lua image based on Amazon Linux 2023

  @id:nginx.container-runtime.entrypoint.117 @rule:container-runtime.entrypoint.non-executable-hooks-skipped @inferred @source:nginx/1.27.2/amazonlinux/2023.6.20241111.0/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: A hook without execute permission is skipped with a notice
    Given a custom hook script 40-custom.sh that is not executable is mounted in /docker-entrypoint.d/
    When the operator starts the container with the default nginx command
    Then the log shows "Ignoring /docker-entrypoint.d/40-custom.sh, not executable"
    And the remaining hooks still run and nginx starts

  @id:nginx.container-runtime.entrypoint.120 @rule:container-runtime.entrypoint.support-banner-and-usage-ping @inferred @source:nginx/1.27.2/amazonlinux/2023.6.20241111.0/tpl/support.sh#support @questionable
  Scenario Outline: Every start prints a sponsorship banner and reports a usage hit unless opted out
    Given SKIP_TRACK is <SKIP_TRACK>
    When the operator starts the container
    Then a "Support the Project" banner is printed
    And whether a request carrying the OS id "amzn" and the nginx version is sent to kodebeat.com with a 5 second timeout is <usage request sent>

    Examples:
      | SKIP_TRACK | usage request sent |
      | unset      | yes                |
      | 0          | yes                |
      | 1          | no                 |
