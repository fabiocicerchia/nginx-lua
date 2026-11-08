@domain:publishing @area:registry-push @from:bin/docker-push
Feature: Pushing per-architecture images to the registry
  Lets a release operator publish the mainline and stable nginx images for one OS distribution from the machine that built them.

  Background:
    Given Supported versions list nginx mainline, nginx stable and the OS version for the distribution

  @id:bin.publishing.registry-push.006 @rule:publishing.registry-push.mainline-then-stable-stop-on-failure @inferred @source:bin/docker-push.py#main
  Scenario: Mainline and stable images are pushed in order and a failed push stops the release
    Given the supported versions list nginx mainline 1.27.3 and nginx stable 1.26.2 for alpine
    And pushing the mainline image tagged 1.27.3 fails
    When the operator pushes the images for alpine
    Then the mainline images are pushed first
    And the operator sees "FATAL: Failed to push image" followed by the failing tag
    And the command exits with status 1
    And no stable images are pushed

  @id:bin.publishing.registry-push.007 @rule:publishing.registry-push.only-own-architecture @inferred @source:bin/docker-push.py#detect_arch @questionable
  Scenario Outline: Only the images for the machine's own architecture are pushed
    Given the machine reports <machine>
    When the operator pushes the images for debian
    Then images are pushed for <pushed>
    And a warning "Unknown machine type" is shown: <warning>

    Examples:
      | machine | pushed            | warning |
      | x86_64  | amd64 only        | no      |
      | aarch64 | arm64v8 only      | no      |
      | riscv64 | all architectures | yes     |
