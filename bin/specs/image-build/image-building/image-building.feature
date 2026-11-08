@domain:image-build @area:image-building @from:bin/docker-ops
Feature: Building reproducible images
  Lets the release operator rebuild a commit and get the same image, so signatures on published tags remain valid.

  @id:bin.image-build.image-building.004 @rule:image-build.image-building.build-date-from-commit @inferred @source:bin/docker_ops.py#get_build_date
  Scenario: An image's build date is the commit's date, so rebuilding the same commit gives the same image
    Given the checked-out commit was made on 2026-03-14 (UTC)
    When the release operator builds the image on any later day
    Then the image is built with build date 2026-03-14T00:00:00Z
