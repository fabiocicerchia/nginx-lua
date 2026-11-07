@domain:operations @area:registry-cleanup @from:bin/cleanup-docker-images
Feature: Removing temporary per-architecture tags from Docker Hub
  Lets the maintainer clear superseded single-architecture tags from the published Docker Hub repository so users only see the signed multi-arch tags.

  Background:
    Given the Docker Hub repository fabiocicerchia/nginx-lua

  @id:bin.operations.registry-cleanup.001 @rule:registry.cleanup.missing-credentials-refused @inferred @source:bin/cleanup-docker-images.py#main
  Scenario Outline: Cleanup refuses to run without Docker Hub credentials
    Given <missing> is not set
    When the operator runs the Docker Hub tag cleanup
    Then the operator sees "ERROR: DOCKER_HUB_USER and DOCKER_HUB_TOKEN must be set"
    And the run exits with status 1
    And no tag is removed from the repository

    Examples:
      | missing          |
      | DOCKER_HUB_USER  |
      | DOCKER_HUB_TOKEN |

  @id:bin.operations.registry-cleanup.002 @rule:registry.cleanup.only-per-arch-tags-removed @inferred @source:bin/cleanup-docker-images.py#should_delete
  Scenario Outline: Only tags ending in an architecture suffix are removed
    Given valid Docker Hub credentials with delete permission
    And the repository has the tag "<tag>"
    When the operator runs the Docker Hub tag cleanup
    Then the tag "<tag>" is <outcome>
    And the run ends with "=== Done. Cleaned up <n> temporary tags. ==="

    Examples:
      | tag                   | outcome | n |
      | 1.27.1.2-alpine-amd64 | removed | 1 |
      | latest-arm64v8        | removed | 1 |
      | 1.27.1.2-alpine       | kept    | 0 |
      | latest                | kept    | 0 |
      | 1.27.1.2-alpine-arm64 | kept    | 0 |

  @id:bin.operations.registry-cleanup.003 @rule:registry.cleanup.aborts-on-repeated-permission-denials @inferred @source:bin/cleanup-docker-images.py#main
  Scenario: Cleanup aborts after five permission denials in a row
    Given a Docker Hub token without delete permission
    And the repository has at least five tags ending in "-amd64"
    When the operator runs the Docker Hub tag cleanup
    Then the operator sees "WARN: HTTP 403 (token lacks delete permission?)" for each of the first five tags
    And the operator sees that DOCKER_HUB_TOKEN must be a Personal Access Token with 'Delete' scope and the account must own or admin the repository
    And the run exits with status 1 without trying the remaining tags

  @id:bin.operations.registry-cleanup.004 @rule:registry.cleanup.other-delete-failures-skipped @inferred @source:bin/cleanup-docker-images.py#main @questionable
  Scenario Outline: A tag that cannot be removed for another reason is skipped and the run continues
    Given valid Docker Hub credentials with delete permission
    And Docker Hub answers the removal of "latest-amd64" with HTTP <status>
    When the operator runs the Docker Hub tag cleanup
    Then the operator sees "WARN: Delete returned HTTP <status>"
    And the remaining temporary tags are still processed
    And "latest-amd64" is not counted in the cleaned-up total
    And the run exits with status 0

    Examples:
      | status |
      | 404    |
      | 500    |
      | 429    |

  @id:bin.operations.registry-cleanup.005 @rule:registry.cleanup.login-failure-stops-run @inferred @source:bin/cleanup-docker-images.py#get_token @questionable
  Scenario: Rejected Docker Hub credentials stop the run before any tag is removed
    Given DOCKER_HUB_USER and DOCKER_HUB_TOKEN are set but Docker Hub rejects the login
    When the operator runs the Docker Hub tag cleanup
    Then the run stops with a non-zero exit status after "=== Fetching Docker Hub token ==="
    And no tag is listed or removed
