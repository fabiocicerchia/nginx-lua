@domain:image-build @area:dockerfile-generation @from:nginx-lua/makefile
Feature: Skipping image work when nothing relevant changed
  Saves maintainers CI time by skipping image build, test, security scan, push, bundle and mirror steps when no nginx or src files changed, with a way to force them.

  @id:image-build.dockerfile-generation.001 @rule:build.pipeline.skip-when-no-image-changes @inferred @source:Makefile#build-single @questionable
  Scenario Outline: Image steps are skipped when no nginx or src files changed, unless forced
    Given the latest commit on main <changes> files under nginx/ or src/
    When the maintainer runs the "<target>" step with FORCE set to "<force>"
    Then <outcome>

    Examples:
      | changes    | target                   | force | outcome                                                        |
      | changes no | build-amd64-alpine       | NO    | the output shows "SKIPPING build-single" and no image is built |
      | changes no | push-alpine              | NO    | the output shows "SKIPPING push-alpine" and nothing is pushed  |
      | changes no | build-amd64-alpine       | YES   | the output shows "BUILDING alpine" and the image is built      |
      | changes    | docker-test-arm64-debian | NO    | the output shows "TESTING debian" and the image is tested      |
