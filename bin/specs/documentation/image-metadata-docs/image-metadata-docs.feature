@domain:documentation @area:image-metadata-docs @from:bin/docker-ops
Feature: Publishing image inspection metadata
  Gives users a markdown page per released image showing its full inspection metadata.

  @id:bin.documentation.image-metadata-docs.004 @rule:documentation.metadata.page-per-tag @inferred @source:bin/docker_ops.py#generate_metadata
  Scenario: Each released image gets a markdown page with its inspection metadata
    Given the image "fabiocicerchia/nginx-lua:1.31.0-alpine3.22" is available locally or from the registry
    When the operator generates the metadata docs for alpine
    Then the file "docs/metadata/1.31.0-alpine3.22.md" is written
    And it starts with the heading "# fabiocicerchia/nginx-lua:1.31.0-alpine3.22"
    And it contains the image's inspection output in a json code block
    And a page is written the same way for the stable release

  @id:bin.documentation.image-metadata-docs.005 @rule:documentation.metadata.unavailable-image-skipped-silently @inferred @source:bin/docker_ops.py#generate_metadata @questionable
  Scenario: An image that cannot be found is skipped without failing the run
    Given the image "fabiocicerchia/nginx-lua:1.30.1-alpine3.22" is neither local nor pullable from the registry
    When the operator generates the metadata docs for alpine
    Then no page is written or updated for "1.30.1-alpine3.22"
    And no error is reported
    And the run exits with status 0
