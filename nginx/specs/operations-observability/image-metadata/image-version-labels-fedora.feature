@domain:operations-observability @area:image-metadata @from:1-19-3/fedora
Feature: Image metadata labels
  Lets operators and registry tooling see which nginx, OS and bundled-module versions an image contains without running it.

  Background:
    Given the nginx-lua 1.19.3 Fedora 33 image

  @id:nginx.operations-observability.image-metadata.026 @rule:image.metadata.version-labels @inferred @source:nginx/1.19.3/fedora/33/Dockerfile#LABEL @questionable
  Scenario: Version and build labels on Fedora images are published empty
    Given the image was built with BUILD_DATE "2026-11-07T10:00:00Z" and VCS_REF "374a60cd"
    When the operator inspects the image labels
    Then "versions.nginx", "versions.lua-nginx-module" and "versions.os" are empty
    And "org.label-schema.build-date" and "org.label-schema.vcs-ref" are empty
    And "org.label-schema.description" reads "Nginx  with Lua support based on  ."
