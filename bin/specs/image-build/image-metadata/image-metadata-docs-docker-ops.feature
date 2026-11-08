@domain:image-build @area:image-metadata @from:bin/docker-ops
Feature: Documenting published image metadata
  Gives maintainers a metadata page per image tag describing what the image contains.

  @id:bin.image-build.image-metadata.003 @rule:image-build.image-metadata.metadata-page-per-tag @inferred @source:bin/docker_ops.py#generate_metadata
  Scenario: A metadata page is written for an image tag when the image can be inspected
    Given the image for tag 1.27.0-alpine3.20 is available locally or in the registry
    When the maintainer generates its metadata
    Then a page docs/metadata/1.27.0-alpine3.20.md is written
    And it starts with the image reference as a heading followed by the image's inspection details as JSON

  @id:bin.image-build.image-metadata.004 @rule:image-build.image-metadata.unavailable-image-silently-skipped @inferred @source:bin/docker_ops.py#generate_metadata @questionable
  Scenario: An image that cannot be fetched is skipped without error
    Given the image tag is neither local nor pullable
    When the maintainer generates its metadata
    Then no metadata page is written
    And the command still exits with code 0
