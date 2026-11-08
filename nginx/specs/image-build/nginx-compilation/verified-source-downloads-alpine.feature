@domain:image-build @area:nginx-compilation @from:1-30-2/alpine
Feature: Verified source downloads at build time
  Protects image consumers from tampered or drifted upstream sources by checking pinned checksums while building.

  Background:
    Given an image build is downloading an upstream source archive

  @id:nginx.image-build.nginx-compilation.007 @rule:image.supply-chain.checksum-mismatch-fails-build @inferred @source:nginx/1.30.2/alpine/3.23.4/tpl/Makefile#secure_download
  Scenario: A download that does not match its pinned checksum fails the build
    Given a SHA256 checksum is pinned for the archive
    And the downloaded archive has a different checksum
    When the maintainer builds the image
    Then the build prints "FATAL: SHA256 checksum mismatch" with the expected and actual values
    And the downloaded file is deleted
    And the build stops with an error

  @id:nginx.image-build.nginx-compilation.008 @rule:image.supply-chain.unpinned-download-allowed-with-warning @inferred @source:nginx/1.30.2/alpine/3.23.4/tpl/Makefile#secure_download @questionable
  Scenario: A download with no pinned checksum proceeds with a warning
    Given no checksum is pinned for the archive
    When the maintainer builds the image
    Then the build prints "WARNING: No checksum pinned" with the actual SHA256
    And the build continues
