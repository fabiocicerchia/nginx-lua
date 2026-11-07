@domain:publishing @area:registry-push @from:bin/docker-push
Feature: Pushing per-architecture images to Docker Hub
  Lets the release operator (or a CI runner) publish the images built on one machine for one distribution, for both the nginx mainline and stable releases, so the multi-arch bundle step has per-arch images to combine.

  Background:
    Given the supported versions list names an nginx mainline release, an nginx stable release and an OS version for each distribution
    And per-architecture images for the distribution have been built locally

  @id:bin.publishing.registry-push.003 @rule:publishing.registry-push.mainline-and-stable-per-distro @inferred @source:bin/docker-push.py#main
  Scenario: Pushing a distribution publishes both its mainline and stable images
    Given the supported versions list has mainline "1.29.3", stable "1.28.0" and alpine "3.22"
    And the operator is on an x86_64 machine
    When the operator pushes images for distribution "alpine"
    Then every amd64 tag of the 1.29.3 alpine 3.22 image is pushed to Docker Hub
    And then every amd64 tag of the 1.28.0 alpine 3.22 image is pushed to Docker Hub
    And the command exits with status 0

  @id:bin.publishing.registry-push.004 @rule:publishing.registry-push.only-local-architecture @inferred @source:bin/docker-push.py#detect_arch
  Scenario Outline: Only images for the machine's own architecture are pushed
    Given the operator is on a machine reporting architecture "<machine>"
    When the operator pushes images for distribution "debian"
    Then only tags ending in "-<arch>" are pushed
    And tags for the other architecture are not pushed

    Examples:
      | machine | arch    |
      | x86_64  | amd64   |
      | aarch64 | arm64v8 |

  @id:bin.publishing.registry-push.005 @rule:publishing.registry-push.unknown-machine-pushes-all-architectures @inferred @source:bin/docker-push.py#detect_arch @questionable
  Scenario: On an unknown machine type the operator is warned and both architectures are pushed
    Given the operator is on a machine reporting architecture "riscv64"
    When the operator pushes images for distribution "debian"
    Then the output shows "WARNING: Unknown machine type 'riscv64', will push for all architectures"
    And both amd64 and arm64v8 tags are pushed

  @id:bin.publishing.registry-push.006 @rule:publishing.registry-push.retry-failed-push-once @inferred @source:bin/docker_ops.py#push_docker_image
  Scenario: A failed image push is retried once before giving up
    Given the first push of tag "fabiocicerchia/nginx-lua:1.29.3-alpine3.22-amd64" fails
    And the second push of that tag succeeds
    When the operator pushes images for distribution "alpine"
    Then the tag is pushed twice
    And the remaining tags are pushed
    And the command exits with status 0

  @id:bin.publishing.registry-push.007 @rule:publishing.registry-push.stop-on-failed-push @inferred @source:bin/docker_ops.py#push_images
  Scenario: A push that fails twice stops the whole run with an error
    Given every push of tag "fabiocicerchia/nginx-lua:1.29.3-alpine3.22-amd64" fails
    When the operator pushes images for distribution "alpine"
    Then the output shows "FATAL: Failed to push image fabiocicerchia/nginx-lua:1.29.3-alpine3.22-amd64"
    And no further tags are pushed, including the stable release's
    And the command exits with status 1
