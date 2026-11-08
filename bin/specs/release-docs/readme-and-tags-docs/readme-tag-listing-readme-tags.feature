@domain:release-docs @area:readme-and-tags-docs @from:bin/readme-tags
Feature: Listing published image tags for the README
  Lets a maintainer regenerate the README tag list so users see which image tags exist for each supported OS and where each Dockerfile lives.

  @id:bin.release-docs.readme-and-tags-docs.003 @rule:release-docs.readme-tags.one-line-per-os-mainline @inferred @source:bin/readme-tags.py#main @questionable
  Scenario: The README tag list has one linked entry per supported OS for the mainline nginx version
    Given the supported versions list names a mainline nginx version and a version for each supported OS
    When the maintainer generates the README tag list
    Then one markdown bullet is printed for each supported OS, in the supported OS order
    And each bullet lists that OS's mainline image tags in backticks, separated by commas
    And each bullet links to that variant's Dockerfile on the main branch of the nginx-lua GitHub repository
    And no bullets are printed for the stable nginx version
