@domain:developer-tooling @area:build-targets @from:src/makefile
Feature: Building a trustworthy image
  Serves the maintainer building the image: downloaded sources must match pinned checksums and the built server must identify itself as nginx.

  Background:
    Given Given the maintainer builds the image with the project Makefile

  @id:src.developer-tooling.build-targets.001 @rule:build.supply-chain.download-checksum-enforced @inferred @source:src/Makefile#secure_download
  Scenario: A downloaded source whose checksum differs from the pinned one stops the build
    Given a pinned SHA256 checksum exists for a dependency
    When the maintainer runs the build and the downloaded archive has a different checksum
    Then the build prints "FATAL: SHA256 checksum mismatch" with the expected and actual values
    And the build exits with a failure
    And the downloaded archive is deleted

  @id:src.developer-tooling.build-targets.002 @rule:build.supply-chain.unpinned-checksum-warned @inferred @source:src/Makefile#secure_download @questionable
  Scenario: A dependency without a pinned checksum is downloaded with a warning
    Given no checksum, or RECOMPUTE_REQUIRED, is pinned for a dependency
    When the maintainer runs the build
    Then the build prints "WARNING: No checksum pinned" with the actual SHA256
    And the build continues

  @id:src.developer-tooling.build-targets.003 @rule:build.branding.server-header-stays-nginx @inferred @source:src/Makefile#openresty-patches
  Scenario: The built server identifies itself as nginx, not openresty
    Given the openresty patch set contains a Server-header rewrite patch
    When the maintainer builds the image
    Then the patch whose name contains server_header is skipped
    And other patches that apply cleanly are applied
    And a patch that does not apply cleanly is skipped with a WARNING and the build continues
    And the build fails with "FATAL: openresty branding survived" if openresty remains in the header sources
