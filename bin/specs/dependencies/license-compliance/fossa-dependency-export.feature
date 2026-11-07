@domain:dependencies @area:license-compliance @from:bin/generate-fossa-deps
Feature: Exporting bundled dependencies for license scanning
  Gives the compliance team a FOSSA remote-dependencies manifest that lists exactly the module versions pinned for the images, so license and vulnerability scans cover what actually ships.

  Background:
    Given the dependency manifest lists the bundled nginx and Lua modules with their FOSSA name, repository and archive pattern

  @id:bin.dependencies.license-compliance.001 @rule:dependencies.license-compliance.manifest-lists-pinned-versions @inferred @source:bin/generate-fossa-deps.py#main
  Scenario Outline: Every bundled module is listed with its pinned version and source archive
    Given module <module> is pinned to version <version> in the pinned versions file
    And the module is pinned by <pin_kind>
    When the operator generates the FOSSA dependency manifest
    Then fossa-deps.yml starts with "remote-dependencies:"
    And it has an entry named <module> with version "<version>" and url "<url>"
    And the entry is preceded by a comment pointing to "<source_link>"
    And the operator sees "Wrote" followed by the path of fossa-deps.yml

    Examples:
      | module           | version | pin_kind | url                                                                   | source_link                                                   |
      | ngx_devel_kit    | 0.3.4   | tag      | https://github.com/vision5/ngx_devel_kit/archive/v0.3.4.tar.gz        | https://github.com/vision5/ngx_devel_kit/tags                 |
      | lua-resty-cookie | 3edcd96 | commit   | https://github.com/cloudflare/lua-resty-cookie/archive/3edcd96.tar.gz | https://github.com/cloudflare/lua-resty-cookie/commits/master |

  @id:bin.dependencies.license-compliance.002 @rule:dependencies.license-compliance.missing-pin-refused @inferred @source:bin/generate-fossa-deps.py#main
  Scenario: Generation is refused when a bundled module has no pinned version
    Given module lua-resty-dns has no VER_LUA_RESTY_DNS entry in the pinned versions file
    And a previously generated fossa-deps.yml exists
    When the operator generates the FOSSA dependency manifest
    Then the operator sees "ERROR: VER_LUA_RESTY_DNS not found in" followed by the pinned versions file path
    And the command exits with status 1
    And the previously generated fossa-deps.yml is left unchanged

  @id:bin.dependencies.license-compliance.003 @rule:dependencies.license-compliance.static-dependencies-included @inferred @source:bin/generate-fossa-deps.py#main
  Scenario: Fixed-version dependencies are always appended to the manifest
    Given the dependency manifest declares a fixed-version dependency with a name, url and version
    When the operator generates the FOSSA dependency manifest
    Then fossa-deps.yml lists that dependency after all pinned modules
    And its name, url and version appear exactly as declared, each quoted
