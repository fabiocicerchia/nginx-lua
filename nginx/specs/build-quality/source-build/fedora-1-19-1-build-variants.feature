@domain:build-quality @area:source-build @from:1-19-1/fedora
Feature: Building the image with or without extended modules
  Lets maintainers produce the full image or a slimmer one, and stops a broken nginx configuration from shipping.

  @id:nginx.build-quality.source-build.001 @rule:build.source.non-extended-build @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#builder @questionable
  Scenario: Asking for a non-extended image fails the build
    Given the maintainer sets the build argument EXTENDED_IMAGE to 0
    When the maintainer builds the image 1.19.1-fedora32
    Then the build stops while fetching the extra Lua libraries
    And no image without the extended modules is produced

  @id:nginx.build-quality.source-build.002 @rule:build.source.extended-configure-silent-fallback @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#builder @questionable
  Scenario: If the extended modules fail to configure, the image is built without them
    Given EXTENDED_IMAGE is 1
    And nginx's configure step fails when the headers-more or stream-lua module is added
    When the maintainer builds the image 1.19.1-fedora32
    Then the build still succeeds
    And nginx is built without headers-more and stream-lua
    And the label versions.extended still says 1
