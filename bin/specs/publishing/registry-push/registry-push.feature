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

  @id:bin.publishing.registry-push.004 @rule:publishing.registry-push.per-arch-scope @inferred @source:bin/docker_ops.py#push_images
  Scenario: Pushing for one architecture publishes only that architecture's tags
    Given the operator names a single architecture such as arm64v8
    When the release operator pushes the images
    Then only tags carrying that architecture are pushed
    And when no architecture is named, both amd64 and arm64v8 tags are pushed

  @id:bin.publishing.registry-push.005 @rule:publishing.registry-push.multi-arch-manifest-combines-both-architectures @inferred @source:bin/docker_ops.py#bundle_images
  Scenario: Each published tag becomes a multi-arch manifest of the amd64 and arm64v8 images
    Given images tagged <tag>-amd64 and <tag>-arm64v8 have been pushed
    When the release operator bundles the images
    Then the tag <tag> is published as a manifest pointing to both architecture images
    And the bundle fails with exit code 1 as soon as one manifest cannot be created or pushed
    And manifest creation failure is reported as 1, a manifest push failure keeps the push's own exit code
