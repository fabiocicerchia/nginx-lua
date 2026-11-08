@domain:image-build @area:image-metadata @from:bin/docker-metadata
Feature: Publishing image metadata documents
  Lets a release operator produce per-image metadata pages for the mainline and stable nginx builds of an OS distribution, so the documentation shows each published image's details.

  Background:
    Given The supported versions list names an nginx mainline version, an nginx stable version and a version for each OS distribution

  @id:bin.image-build.image-metadata.001 @rule:image-build.image-metadata.mainline-and-stable-pages @inferred @source:bin/docker-metadata.py#main
  Scenario: Metadata pages are written for both the mainline and stable image of a distribution
    Given the supported versions list nginx mainline 1.27.3, nginx stable 1.26.2 and alpine 3.20
    And the images for alpine are available
    When the release operator generates image metadata for alpine
    Then a metadata page named 1.27.3-alpine3.20.md is written to the docs metadata folder
    And a metadata page named 1.26.2-alpine3.20.md is written to the docs metadata folder
    And each page starts with the image reference as a heading, followed by the image inspection details as JSON

  @id:bin.image-build.image-metadata.002 @rule:image-build.image-metadata.missing-image-skipped-silently @inferred @source:bin/docker_ops.py#generate_metadata @questionable
  Scenario: An image that cannot be found or pulled is skipped without failing the run
    Given the image for the requested tag is neither available locally nor pullable
    When the release operator generates image metadata for alpine
    Then no metadata page is written for that tag
    And the command ends with exit status 0
