@domain:release-docs @area:supported-versions @from:bin/common
Feature: Supported versions matrix
  Lets maintainers know exactly which nginx and OS combinations are built and documented.

  @id:bin.release-docs.supported-versions.001 @rule:release-docs.supported-versions.mainline-and-stable-per-os @inferred @source:bin/common.py#get_supported_versions
  Scenario: Every supported OS is built for both mainline and stable nginx
    Given the supported versions list names nginx mainline, nginx stable and a version for each of almalinux, alpine, amazonlinux, debian, fedora and ubuntu
    When the operator lists the supported images
    Then 12 image definitions are listed, two per OS
    And each OS lists mainline first and then stable, at the OS version from the list
    And paths look like "nginx/<nginx_version>/<os>/<os_version>/Dockerfile"
