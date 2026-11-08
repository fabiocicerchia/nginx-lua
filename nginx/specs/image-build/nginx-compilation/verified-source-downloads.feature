@domain:image-build @area:nginx-compilation @from:1-28-3/ubuntu
Feature: Verified source downloads during the build
  Protects image consumers by making the build refuse tampered or drifted nginx and module sources.

  Background:
    Given Expected SHA256 values come from the pinned checksum file next to the Makefile

  @id:nginx.image-build.nginx-compilation.003 @rule:build.downloads.checksum-mismatch-fails-build @inferred @source:nginx/1.28.3/ubuntu/24.04/tpl/Makefile#secure_download
  Scenario: A download whose checksum does not match fails the build
    Given a pinned SHA256 exists for the nginx source archive
    When the maintainer builds the image and the downloaded archive has a different SHA256
    Then the build prints "FATAL: SHA256 checksum mismatch" with expected and actual hashes
    And the downloaded file is deleted
    And the build stops with a failure

  @id:nginx.image-build.nginx-compilation.004 @rule:build.downloads.unpinned-checksum-only-warns @inferred @source:nginx/1.28.3/ubuntu/24.04/tpl/Makefile#secure_download @questionable
  Scenario: A download with no pinned checksum proceeds with a warning
    Given the SHA256 for a dependency is empty or marked RECOMPUTE_REQUIRED
    When the maintainer builds the image
    Then the build prints "WARNING: No checksum pinned" with the actual SHA256
    And the build continues
