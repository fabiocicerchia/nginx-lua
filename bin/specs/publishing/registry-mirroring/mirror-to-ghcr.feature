@domain:publishing @area:registry-mirroring @from:bin/mirror-ghcr
Feature: Mirroring published images to GitHub Container Registry
  Lets users pull the default (alpine) nginx-lua images from GHCR under exactly the same tags Docker Hub publishes, as a secondary distribution channel.

  Background:
    Given the supported versions name an nginx mainline release, an nginx stable release and an alpine version
    And the multi-arch images for those releases are already published on Docker Hub as fabiocicerchia/nginx-lua

  @id:bin.publishing.registry-mirroring.001 @rule:publishing.mirroring.same-tags-as-docker-hub @verified @source:bin/mirror-ghcr.py#mirror_images @test:bin/test_mirror_ghcr.py#test_runs_imagetools_create
  Scenario Outline: Every Docker Hub tag of the default distro appears on GHCR under the same name
    Given nginx <release> is the <channel> release
    And alpine 3.22 is the supported alpine version
    When the operator mirrors the images to GHCR
    Then ghcr.io/fabiocicerchia/nginx-lua/nginx-lua:<tag> points at the same multi-arch image as fabiocicerchia/nginx-lua:<tag>
    And the GHCR tag set for nginx <release> is exactly the Docker Hub tag set for that release
    And <channel_only_tags> are mirrored only from the mainline release

    Examples:
      | channel  | release | tag               | channel_only_tags                         |
      | mainline | 1.29.3  | 1.29.3-alpine3.22 | latest, 1, alpine, 1-alpine, 1-alpine3.22 |
      | mainline | 1.29.3  | latest            | latest, 1, alpine, 1-alpine, 1-alpine3.22 |
      | stable   | 1.28.0  | 1.28-alpine       | latest, 1, alpine, 1-alpine, 1-alpine3.22 |
      | stable   | 1.28.0  | 1.28.0            | latest, 1, alpine, 1-alpine, 1-alpine3.22 |

  @id:bin.publishing.registry-mirroring.002 @rule:publishing.mirroring.default-distro-only @inferred @source:bin/mirror-ghcr.py#main
  Scenario: Only the default alpine images are mirrored to GHCR
    Given Docker Hub also carries debian, ubuntu, fedora, almalinux and amazonlinux images
    When the operator mirrors the images to GHCR
    Then only alpine tags such as 1.29.3-alpine are copied to GHCR
    And no tag such as 1.29.3-debian is copied to GHCR

  @id:bin.publishing.registry-mirroring.003 @rule:publishing.mirroring.dry-run-touches-no-registry @inferred @source:bin/mirror-ghcr.py#mirror_images
  Scenario: A dry run lists the copy commands without changing any registry
    When the operator mirrors the images to GHCR with --dry-run
    Then one line per tag is printed, such as "docker buildx imagetools create -t ghcr.io/fabiocicerchia/nginx-lua/nginx-lua:1.29.3-alpine fabiocicerchia/nginx-lua:1.29.3-alpine"
    And lines are printed for both the mainline and the stable release
    And no tag on GHCR is created or moved

  @id:bin.publishing.registry-mirroring.004 @rule:publishing.mirroring.stops-on-first-failure @verified @source:bin/mirror-ghcr.py#mirror_images @test:bin/test_mirror_ghcr.py#test_failure_propagates
  Scenario Outline: Mirroring stops at the first tag that cannot be copied and reports failure
    Given copying tag <failing_tag> to GHCR is refused
    When the operator mirrors the images to GHCR
    Then "FATAL: Failed to mirror fabiocicerchia/nginx-lua:<failing_tag> to ghcr.io/fabiocicerchia/nginx-lua/nginx-lua:<failing_tag>" is printed
    And no further tags are copied, <skipped> included
    And the mirror run exits with status 1
    And tags copied before the failure stay on GHCR

    Examples:
      | failing_tag   | skipped                           |
      | 1.29.3-alpine | every stable release tag          |
      | 1.28.0-alpine | the remaining stable release tags |
