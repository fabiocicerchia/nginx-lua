@domain:shared-tooling @area:retry-resilience @from:bin/lib-retry
Feature: Retrying registry operations that hit rate limits
  Operators running image and manifest signing need transient Docker rate-limit refusals retried automatically, while real failures still surface at once.

  @id:bin.shared-tooling.retry-resilience.001 @rule:shared-tooling.retry.rate-limit-is-retried @inferred @source:bin/lib-retry.sh#retry_on_rate_limit
  Scenario: A command refused for rate limiting is retried until it succeeds
    Given a signing command that is refused with TOOMANYREQUESTS on its first two runs and succeeds on the third
    When the operator runs the command through the retry helper
    Then the operator sees "Rate limited – retrying in 2s (attempt 1/4)…"
    And the operator sees "Rate limited – retrying in 4s (attempt 2/4)…"
    And the command's successful output is shown
    And the helper exits with status 0

  @id:bin.shared-tooling.retry-resilience.002 @rule:shared-tooling.retry.gives-up-after-max-retries @inferred @source:bin/lib-retry.sh#retry_on_rate_limit
  Scenario: Retrying stops after the configured maximum and reports the failure
    Given a command that is always refused with a rate-limit error
    And the maximum retries set to 2
    When the operator runs the command through the retry helper
    Then the operator sees retry messages for attempts 1/2 and 2/2
    And the last refusal output is shown
    And the helper exits with the command's own non-zero status

  @id:bin.shared-tooling.retry-resilience.003 @rule:shared-tooling.retry.other-failures-fail-immediately @inferred @source:bin/lib-retry.sh#retry_on_rate_limit @questionable
  Scenario: A failure that is not rate limiting is not retried
    Given a command that fails with "unauthorized: authentication required"
    When the operator runs the command through the retry helper
    Then no retry message is shown
    And the failure output is shown
    And the helper exits with the command's own non-zero status
