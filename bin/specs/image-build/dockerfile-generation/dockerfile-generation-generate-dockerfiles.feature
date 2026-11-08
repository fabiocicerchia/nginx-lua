@domain:image-build @area:dockerfile-generation @from:bin/generate-dockerfiles
Feature: Generating Dockerfiles for every supported nginx and OS combination
  Lets maintainers produce a ready-to-build Dockerfile for each supported nginx release on each supported OS, plus a default Dockerfile at the repository root.

  @id:bin.image-build.dockerfile-generation.003 @rule:image-build.dockerfile-generation.covers-mainline-and-stable-per-os @inferred @source:bin/generate-dockerfiles.py#main
  Scenario: A Dockerfile is generated for both mainline and stable nginx on every supported OS
    Given the supported versions list names an nginx mainline version, an nginx stable version and a version for each supported OS
    When the maintainer generates the Dockerfiles
    Then a Dockerfile exists for the mainline nginx version on each supported OS at that OS's listed version
    And a Dockerfile exists for the stable nginx version on each supported OS at that OS's listed version
    And each Dockerfile has the nginx version, OS name and OS version filled in with no unfilled placeholders for those values

  @id:bin.image-build.dockerfile-generation.004 @rule:image-build.dockerfile-generation.root-dockerfile-is-newest-alpine @inferred @source:bin/generate-dockerfiles.py#main @questionable
  Scenario: The root Dockerfile is a copy of the newest Alpine Dockerfile
    Given Dockerfiles have been generated for several nginx and Alpine versions
    When the maintainer generates the Dockerfiles
    Then the Dockerfile at the repository root is identical to the Alpine Dockerfile whose path sorts highest
