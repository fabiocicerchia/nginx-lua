@domain:distribution @area:rhel-family-images @from:1-19-1/fedora
Feature: Running nginx 1.19.1 with Lua on Fedora
  Gives operators who standardise on Fedora an nginx 1.19.1 image with Lua scripting built in, for Fedora 32 and Fedora 33.

  @id:nginx.distribution.rhel-family-images.029 @rule:distribution.fedora.nginx-1-19-1-with-lua-per-fedora-release @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#base
  Scenario Outline: Each supported Fedora release gets an nginx 1.19.1 image with the Lua modules built in
    Given the image 1.19.1-fedora<release> is built with default settings
    When the operator asks nginx inside the container for its version and build options
    Then nginx reports version 1.19.1
    And the build options include lua-nginx-module 0.10.15 and ngx_devel_kit 0.3.1
    And the build options include headers-more-nginx-module and stream-lua-nginx-module 0.0.8rc3
    And the image runs on Fedora <release>

    Examples:
      | release |
      | 32      |
      | 33      |

  @id:nginx.distribution.rhel-family-images.030 @rule:distribution.architectures.process-supervisor-matches-cpu @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#dumb-init @questionable
  Scenario: The container's process supervisor is always the x86_64 build, whatever the CPU architecture
    Given the image 1.19.1-fedora32 is built on an arm64 host
    When the operator starts the container
    Then the dumb-init installed as the entrypoint is the x86_64 binary
    And the container cannot launch nginx on the arm64 host
