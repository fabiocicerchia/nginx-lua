@domain:operations @area:retry-handling @from:bin/lib-retry
Feature: Retrying registry-rate-limited signing steps
  Lets the release operator get images signed, attested and verified despite transient Docker registry rate limits, without masking real failures.

  Background:
    Given the operator runs image or manifest signing in CI (sign-image or sign-manifest)
    And each signing step (cosign sign, syft SBOM generation, cosign attest, cosign verify) is run through the rate-limit retry

  @id:bin.operations.retry-handling.001 @rule:operations.retry-handling.rate-limited-step-retried @inferred @source:bin/lib-retry.sh#retry_on_rate_limit
  Scenario: A rate-limited signing step is retried with growing waits and succeeds
    Given the registry answers the first cosign sign attempt with "TOOMANYREQUESTS: rate limit exceeded"
    And the second attempt succeeds
    When the operator signs the image fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3-amd64
    Then the log shows "Rate limited – retrying in 2s (attempt 1/4)…"
    And the log then shows the output of the successful attempt only
    And the signing step reports success and signing continues

  @id:bin.operations.retry-handling.002 @rule:operations.retry-handling.non-rate-limit-failure-fails-fast @inferred @source:bin/lib-retry.sh#retry_on_rate_limit
  Scenario: A signing failure that is not a rate limit fails at once with its error
    Given cosign sign fails with "no matching signatures: invalid certificate identity" and exit status 1
    When the operator signs the image fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3-amd64
    Then no retry message is shown
    And the log shows the cosign error output
    And the signing run stops with exit status 1

  @id:bin.operations.retry-handling.003 @rule:operations.retry-handling.retry-limit @inferred @source:bin/lib-retry.sh#retry_on_rate_limit
  Scenario Outline: Rate-limit retries stop after the configured limit and the failure is reported
    Given SIGN_MAX_RETRIES is <setting>
    And every cosign attest attempt is rate limited with HTTP 429
    When the operator signs the image fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3-amd64
    Then the log shows <retries> retry messages, the last one "<last_message>"
    And the log shows the rate-limit error of the final attempt
    And the signing run stops with the step's failing exit status

    Examples:
      | setting | retries | last_message                                  |
      | unset   | 4       | Rate limited – retrying in 16s (attempt 4/4)… |
      | 2       | 2       | Rate limited – retrying in 4s (attempt 2/2)…  |
      | 0       | 0       | (none)                                        |

  @id:bin.operations.retry-handling.004 @rule:operations.retry-handling.rate-limit-detection @inferred @source:bin/lib-retry.sh#retry_on_rate_limit @questionable
  Scenario Outline: Any failure whose output mentions 429 or a rate limit is treated as rate limited
    Given a signing step fails with output "<failure_output>"
    When the operator signs the image fabiocicerchia/nginx-lua:1.29.7-alpine3.23.3-amd64
    Then the step is <outcome>

    Examples:
      | failure_output                                         | outcome     |
      | toomanyrequests: You have reached your pull rate limit | retried     |
      | HTTP 429 Too Many Requests                             | retried     |
      | Rate Limit exceeded                                    | retried     |
      | MANIFEST_UNKNOWN: sha256:4290ab... not found           | retried     |
      | UNAUTHORIZED: authentication required                  | not retried |
