@domain:image-build @area:build-tooling @from:bin/common
Feature: Running image operations for mainline and stable
  Lets operators build, bundle, push and mirror both nginx tracks in one command and see the run fail as soon as a step fails.

  @id:bin.image-build.build-tooling.001 @rule:build.runs.stop-on-first-failure @inferred @source:bin/common.py#for_mainline_and_stable
  Scenario: A failing mainline step stops the run before stable is processed
    Given the operation for the mainline build of debian fails
    When the operator runs an image operation for debian
    Then the command exits with status 1
    And the stable build of debian is not processed
