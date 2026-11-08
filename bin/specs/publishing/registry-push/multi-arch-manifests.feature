@domain:publishing @area:registry-push @from:bin/docker-bundle
Feature: Publishing multi-architecture manifests
  Lets operators publish one tag per nginx-lua image that serves both amd64 and arm64v8 users.

  Background:
    Given The supported versions file lists the current nginx mainline and stable versions and the version of each OS distribution

  @id:bin.publishing.registry-push.001 @rule:publishing.manifests.bundle-both-architectures-per-tag @inferred @source:bin/docker-bundle.py#main
  Scenario: Each image tag is published as one manifest covering amd64 and arm64v8
    Given the supported versions list nginx mainline 1.27.2 and stable 1.26.2 and alpine 3.20
    And architecture-specific images exist for every tag of those versions
    When the operator bundles the images for the "alpine" distribution
    Then for every tag of the mainline version and then of the stable version, a manifest is created from the "-amd64" and "-arm64v8" images
    And each manifest is pushed under the plain tag without an architecture suffix
    And the command exits with status 0

  @id:bin.publishing.registry-push.002 @rule:publishing.manifests.stop-on-first-failure @inferred @source:bin/docker_ops.py#bundle_images
  Scenario: Bundling stops with a failure status at the first manifest that cannot be published
    Given the supported versions list a mainline and a stable nginx version
    And the arm64v8 image of the first mainline tag was never built
    When the operator bundles the images for the "alpine" distribution
    Then no further tags are bundled, including the stable version
    And the command exits with status 1
