@domain:dependencies @area:license-inventory @from:bin/generate-fossa-deps
Feature: Generating the license-scan dependency declarations
  Lets the compliance owner keep the FOSSA remote-dependencies file in step with the versions pinned for the images, so license and vulnerability scans cover what is actually shipped.

  Background:
    Given The pinned versions live in the src/ distributed environment defaults file as VER_<NAME> entries

  @id:bin.dependencies.license-inventory.001 @rule:dependencies.license-inventory.declarations-match-pinned-versions @inferred @source:bin/generate-fossa-deps.py#main
  Scenario: The scan declarations list every component at its pinned version
    Given the pinned versions file sets VER_LUA_NGINX_MODULE to 0.10.26
    When the maintainer runs the FOSSA dependency generator
    Then fossa-deps.yml starts with "remote-dependencies:"
    And the entry for each manifest component carries the download URL built from the pinned version
    And the entry shows version "0.10.26" for that component
    And each entry is preceded by a comment naming its repository and "tags" or "commits/master"
    And the command prints "Wrote" followed by the file path

  @id:bin.dependencies.license-inventory.002 @rule:dependencies.license-inventory.static-components-always-listed @inferred @source:bin/generate-fossa-deps.py#main
  Scenario: Components with fixed versions are always declared
    Given the manifest has components with a fixed URL and version
    When the maintainer runs the FOSSA dependency generator
    Then fossa-deps.yml lists each fixed component after the pinned ones, with its fixed URL and version

  @id:bin.dependencies.license-inventory.003 @rule:dependencies.license-inventory.refuses-unpinned-component @inferred @source:bin/generate-fossa-deps.py#main
  Scenario: Generation stops when a component has no pinned version
    Given the pinned versions file has no VER_ entry for a component in the manifest
    When the maintainer runs the FOSSA dependency generator
    Then the command exits with status 1
    And the error message names the missing VER_ key and the pinned versions file
    And fossa-deps.yml is not rewritten
