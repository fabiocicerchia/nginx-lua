@domain:publishing @area:registry-push @from:bin/docker-ops
Feature: Publishing per-architecture images and multi-arch manifests
  Lets the release operator publish each architecture's image and a combined multi-arch tag, and be told clearly when publishing fails.

  Background:
    Given Image tags are computed from the nginx version, OS distro, OS version and architecture

  @id:bin.publishing.registry-push.003 @rule:publishing.registry-push.transient-failure-retried-once @inferred @source:bin/docker_ops.py#push_docker_image
  Scenario: A push is retried once and aborts the release only if the retry also fails
    Given the registry rejects the first push of an image tag
    When the release operator pushes the images for an nginx, OS and architecture combination
    Then the same tag is pushed a second time
    And when the second attempt succeeds the push completes with exit code 0
    And when the second attempt also fails the output shows "FATAL: Failed to push image" with the tag and the exit code is non-zero
    And no further tags are pushed after the failing one
