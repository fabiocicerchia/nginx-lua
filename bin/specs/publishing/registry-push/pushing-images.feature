@domain:publishing @area:registry-push @from:bin/docker-ops
Feature: Pushing images to Docker Hub
  Lets operators publish every per-architecture tag, survive a single transient registry failure, and see clearly when publishing has failed.

  Background:
    Given the <distro> images for the requested architectures have been built

  @id:bin.publishing.registry-push.001 @rule:publishing.push.all-tags-for-requested-arch @inferred @source:bin/docker_ops.py#push_images
  Scenario Outline: Every tag of the requested architecture is pushed, or of both architectures when none is named
    Given the requested architecture is "<requested>"
    When the operator pushes the alpine images
    Then every generated tag for <pushed> is pushed to the registry
    And no tag for any other architecture is pushed

    Examples:
      | requested | pushed            |
      | amd64     | amd64 only        |
      | arm64v8   | arm64v8 only      |
      | none      | amd64 and arm64v8 |

  @id:bin.publishing.registry-push.002 @rule:publishing.push.retry-once-then-fail @inferred @source:bin/docker_ops.py#push_docker_image
  Scenario Outline: A tag that fails to push twice stops publishing with a fatal message
    Given pushing tag "1.31.0-alpine3.22-amd64" fails <failures>
    When the operator pushes the alpine images for amd64
    Then the tag is attempted at most twice
    And <outcome>

    Examples:
      | failures | outcome                                                                                                                           |
      | once     | publishing continues with the remaining tags                                                                                      |
      | twice    | "FATAL: Failed to push image 1.31.0-alpine3.22-amd64" is shown, the remaining tags are not pushed and the run exits with status 1 |
