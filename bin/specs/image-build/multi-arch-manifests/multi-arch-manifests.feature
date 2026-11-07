@domain:image-build @area:multi-arch-manifests @from:bin/docker-ops
Feature: Publishing multi-architecture tags
  Lets image consumers pull one tag that resolves to the right image for amd64 or arm64.

  Background:
    Given the amd64 and arm64v8 images for alpine have been pushed

  @id:bin.image-build.multi-arch-manifests.004 @rule:image-build.manifests.tag-combines-both-arches @inferred @source:bin/docker_ops.py#create_manifest
  Scenario: Each published tag resolves to both the amd64 and the arm64v8 image
    Given the tags "1.31.0-alpine3.22-amd64" and "1.31.0-alpine3.22-arm64v8" exist in the registry
    When the operator bundles the alpine images
    Then the tag "1.31.0-alpine3.22" is pushed as a multi-architecture manifest
    And that manifest lists "1.31.0-alpine3.22-amd64" and "1.31.0-alpine3.22-arm64v8"
    And every other generated tag without an architecture suffix gets a manifest in the same way

  @id:bin.image-build.multi-arch-manifests.005 @rule:image-build.manifests.failure-stops-bundling @inferred @source:bin/docker_ops.py#bundle_images
  Scenario: A tag whose manifest cannot be created stops bundling
    Given the arm64v8 image for tag "1.31.0-alpine3.22" is missing from the registry
    When the operator bundles the alpine images
    Then no manifest is pushed for "1.31.0-alpine3.22"
    And no further tags are bundled
    And the run exits with status 1
