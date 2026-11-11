@domain:publishing @area:registry-mirroring @from:bin/mirror-ghcr
Feature: Mirroring published images to GitHub Container Registry
  Lets operators publish the default-distro nginx-lua images to GHCR as a secondary channel carrying the same tags as Docker Hub.

  Background:
    Given the supported versions list defines a mainline and a stable nginx version and the alpine version

  @id:bin.publishing.registry-mirroring.001 @rule:publishing.registry-mirroring.same-tags-as-docker-hub @inferred @source:bin/mirror-ghcr.py#mirror_images
  Scenario: Every Docker Hub tag of the default distro is copied to GHCR
    Given the multi-arch manifest lists for alpine are published on Docker Hub for the mainline and stable nginx versions
    When the operator runs the GHCR mirror
    Then each Docker Hub tag of fabiocicerchia/nginx-lua is created as the same tag under ghcr.io/fabiocicerchia/nginx-lua/nginx-lua
    And the mainline version tags are mirrored before the stable version tags
    And only alpine tags are mirrored; no other distro is copied

  @id:bin.publishing.registry-mirroring.002 @rule:publishing.registry-mirroring.dry-run-changes-nothing @inferred @source:bin/mirror-ghcr.py#mirror_images
  Scenario: A dry run lists the mirror commands without touching any registry
    Given the multi-arch manifest lists for alpine are published on Docker Hub
    When the operator runs the GHCR mirror with --dry-run
    Then one copy command per tag is printed, from the Docker Hub tag to the GHCR tag
    And no tag is created on GHCR
    And the run finishes without error

  @id:bin.publishing.registry-mirroring.003 @rule:publishing.registry-mirroring.stops-on-first-failure @inferred @source:bin/mirror-ghcr.py#mirror_images
  Scenario: The mirror stops with an error when a tag cannot be copied
    Given the registry refuses the copy of one tag
    When the operator runs the GHCR mirror
    Then the message "FATAL: Failed to mirror" naming the source and target tag is shown
    And the remaining tags and the stable version are not mirrored
    And the command exits with status 1
