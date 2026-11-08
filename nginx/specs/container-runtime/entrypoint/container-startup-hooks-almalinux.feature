@domain:container-runtime @area:entrypoint @from:1-29-3/almalinux
Feature: Container startup hooks
  Operators of the AlmaLinux nginx image rely on startup scripts being run in a predictable order before nginx starts.

  Background:
    Given the AlmaLinux nginx-lua image

  @id:nginx.container-runtime.entrypoint.192 @rule:container-runtime.entrypoint.usage-tracking-opt-out @inferred @source:nginx/1.29.3/almalinux/9.7-20251119/tpl/support.sh#support @questionable
  Scenario: Each start reports a usage hit to a third-party service unless opted out
    Given SKIP_TRACK is not set to 1
    When the operator starts the container
    Then the container requests https://kodebeat.com/nginx-lua/stats/hit/boot.php with the OS id and nginx version, waiting at most 5 seconds
    And with SKIP_TRACK=1 no such request is made
