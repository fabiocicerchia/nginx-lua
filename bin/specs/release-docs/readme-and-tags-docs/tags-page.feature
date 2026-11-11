@domain:release-docs @area:readme-and-tags-docs @from:bin/generate-tags
Feature: Tags page
  Gives users a markdown page listing every image tag, split by supported and unsupported versions.

  @id:bin.release-docs.readme-and-tags-docs.002 @rule:release-docs.tags.supported-and-unsupported-split @inferred @source:bin/generate_tags.py#main
  Scenario: The tags page lists supported images first and the rest as unsupported
    Given the supported versions list contains the nginx 1.25.3 alpine 3.20 Dockerfile
    And other Dockerfiles exist for older releases
    When the maintainer generates the tags page
    Then the page begins with the heading Tags and a Supported Tags section
    And each supported Dockerfile has one line linking its comma-separated tags to the file on GitHub
    And the Unsupported Tags section lists every other Dockerfile in reverse path order
