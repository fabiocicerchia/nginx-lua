@domain:publishing @area:image-cleanup @from:bin/cleanup-docker-images
Feature: Cleaning up temporary per-architecture tags
  Lets the release operator remove superseded single-architecture tags from Docker Hub so only the signed multi-arch tags remain.

  Background:
    Given The operator runs the cleanup against the fabiocicerchia/nginx-lua repository on Docker Hub

  @id:bin.publishing.image-cleanup.001 @rule:publishing.image-cleanup.only-per-arch-tags-deleted @inferred @source:bin/cleanup-docker-images.py#should_delete
  Scenario: Only temporary per-architecture tags are deleted
    Given the repository has tags 1.25.3, 1.25.3-amd64 and 1.25.3-arm64v8
    When the operator runs the Docker Hub cleanup
    Then tag 1.25.3-amd64 is deleted
    And tag 1.25.3-arm64v8 is deleted
    And tag 1.25.3 is kept
    And the summary reports "Cleaned up 2 temporary tags"

  @id:bin.publishing.image-cleanup.002 @rule:publishing.image-cleanup.requires-credentials @inferred @source:bin/cleanup-docker-images.py#main
  Scenario: Cleanup refuses to run without Docker Hub credentials
    Given DOCKER_HUB_USER or DOCKER_HUB_TOKEN is not set
    When the operator runs the Docker Hub cleanup
    Then the output says "ERROR: DOCKER_HUB_USER and DOCKER_HUB_TOKEN must be set"
    And the command exits with a failure status
    And no tag is deleted

  @id:bin.publishing.image-cleanup.003 @rule:publishing.image-cleanup.aborts-on-repeated-permission-denial @inferred @source:bin/cleanup-docker-images.py#main
  Scenario: Cleanup aborts when the token repeatedly lacks delete permission
    Given the token has no Delete scope
    And at least 5 temporary tags exist
    When the operator runs the Docker Hub cleanup
    Then each refused delete prints a warning about HTTP 403
    And after 5 consecutive refusals the output says the token must be a Personal Access Token with 'Delete' scope
    And the command exits with a failure status

  @id:bin.publishing.image-cleanup.004 @rule:publishing.image-cleanup.other-failures-do-not-stop-run @inferred @source:bin/cleanup-docker-images.py#main @questionable
  Scenario: A failed delete other than permission denial does not stop the cleanup
    Given deleting tag 1.25.3-amd64 returns HTTP 500
    And tag 1.25.3-arm64v8 can be deleted
    When the operator runs the Docker Hub cleanup
    Then the output warns "Delete returned HTTP 500"
    And tag 1.25.3-arm64v8 is still deleted
    And the command exits with a success status
    And the summary counts only the successful deletes
