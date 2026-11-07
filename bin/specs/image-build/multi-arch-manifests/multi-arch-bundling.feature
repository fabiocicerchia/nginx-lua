@domain:image-build @area:multi-arch-manifests @from:bin/docker-bundle
Feature: Publishing multi-architecture images
  Lets the release operator publish every image tag of a distribution as one multi-arch manifest, so users who pull a tag get the amd64 or arm64 image that matches their machine.

  Background:
    Given the supported versions list names nginx mainline 1.31.2, nginx stable 1.30.1 and alpine 3.22
    And the amd64 and arm64v8 images of every tag are already in the registry

  @id:bin.image-build.multi-arch-manifests.001 @rule:image-build.multi-arch.tag-combines-amd64-and-arm64 @inferred @source:bin/docker_ops.py#create_manifest
  Scenario Outline: Each published tag combines its amd64 and arm64v8 images
    Given the image tag <tag> exists as <tag>-amd64 and <tag>-arm64v8 in the registry
    When the operator bundles the alpine images
    Then the registry has a multi-arch manifest for <tag>
    And the manifest for <tag> points to <tag>-amd64 and <tag>-arm64v8

    Examples:
      | tag                                        |
      | fabiocicerchia/nginx-lua:1.31.2-alpine     |
      | fabiocicerchia/nginx-lua:1.30.1-alpine3.22 |
      | fabiocicerchia/nginx-lua:latest            |

  @id:bin.image-build.multi-arch-manifests.002 @rule:image-build.multi-arch.bundles-mainline-and-stable @inferred @source:bin/docker-bundle.py#main
  Scenario: Bundling a distribution publishes both its mainline and stable tags
    When the operator bundles the alpine images
    Then multi-arch manifests are pushed for every nginx 1.31.2 alpine tag first
    And multi-arch manifests are then pushed for every nginx 1.30.1 alpine tag
    And the major-only tags "1", "latest" and "alpine" are bundled only from the mainline images

  @id:bin.image-build.multi-arch-manifests.003 @rule:image-build.multi-arch.stop-on-first-failure @inferred @source:bin/common.py#for_mainline_and_stable @questionable
  Scenario: Bundling stops and fails at the first tag that cannot be published
    Given the arm64v8 image of fabiocicerchia/nginx-lua:1.31.2-alpine is missing from the registry
    When the operator bundles the alpine images
    Then no further tags are bundled after fabiocicerchia/nginx-lua:1.31.2-alpine
    And no nginx 1.30.1 stable tags are bundled
    And the command exits with status 1
