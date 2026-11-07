@domain:dependencies @area:dependency-manifest @from:bin/deps-manifest
Feature: Declaring the bundled third-party modules
  Maintainers and licence reviewers rely on one declared list of bundled nginx/Lua modules so that the pinned versions used by the image build and the FOSSA licence report always name the same modules.

  Background:
    Given the project bundles 29 third-party nginx and Lua modules plus one vendored source file

  @id:bin.dependencies.dependency-manifest.001 @rule:dependencies.manifest.same-modules-in-pins-and-licence-report @inferred @source:bin/deps_manifest.py#DEPENDENCIES
  Scenario Outline: Every bundled module appears both in the pinned versions file and in the licence report
    Given the bundled module "<module>" is declared in the dependency list
    When the maintainer regenerates the pinned versions file and the licence report
    Then the pinned versions file holds the variable "<version_variable>"
    And the licence report lists the module under the name "<licence_name>" with that same version

    Examples:
      | module            | version_variable      | licence_name              |
      | geoip             | VER_GEOIP             | geoip2                    |
      | luajit            | VER_LUAJIT            | luajit2                   |
      | openresty_headers | VER_OPENRESTY_HEADERS | headers-more-nginx-module |
      | luarocks          | VER_LUAROCKS          | lua-rocks                 |
      | cloudflare_cookie | VER_CLOUDFLARE_COOKIE | lua-resty-cookie          |

  @id:bin.dependencies.dependency-manifest.002 @rule:dependencies.manifest.licence-report-refuses-unpinned-module @inferred @source:bin/generate-fossa-deps.py#main
  Scenario: The licence report is not produced when a bundled module has no pinned version
    Given the bundled module "njs" is declared in the dependency list
    And the pinned versions file has no VER_NJS entry
    When the maintainer regenerates the licence report
    Then the error "ERROR: VER_NJS not found in" followed by the pinned versions file path is shown
    And the command exits with status 1
    And the licence report is left unchanged

  @id:bin.dependencies.dependency-manifest.003 @rule:dependencies.manifest.branch-tracking-modules-pinned-to-commits @inferred @source:bin/deps_manifest.py#DEPENDENCIES @questionable
  Scenario Outline: Modules that track a branch are pinned to a commit, all others to a release tag
    Given the bundled module "<module>" is declared as tracking <tracking>
    When the maintainer regenerates the licence report
    Then the module's source reference in the licence report points to "<reference>"
    And its archive address is "<archive>"

    Examples:
      | module                  | tracking     | reference                                                           | archive                                                                      |
      | lua-resty-cookie        | a branch     | https://github.com/cloudflare/lua-resty-cookie/commits/master       | https://github.com/cloudflare/lua-resty-cookie/archive/<commit>.tar.gz       |
      | stream-lua-nginx-module | a branch     | https://github.com/openresty/stream-lua-nginx-module/commits/master | https://github.com/openresty/stream-lua-nginx-module/archive/<commit>.tar.gz |
      | lua-resty-redis         | release tags | https://github.com/openresty/lua-resty-redis/tags                   | https://github.com/openresty/lua-resty-redis/archive/v<version>.tar.gz       |
      | njs                     | release tags | https://github.com/nginx/njs/tags                                   | https://github.com/nginx/njs/archive/<version>.tar.gz                        |

  @id:bin.dependencies.dependency-manifest.004 @rule:dependencies.manifest.vendored-file-reported-without-version @inferred @source:bin/deps_manifest.py#STATIC_DEPENDENCIES
  Scenario: The vendored SHA header is reported for licensing without a tracked version
    Given the project vendors the SHA implementation by Eric Young from ngx_devel_kit
    When the maintainer regenerates the licence report
    Then the licence report lists "SSL implementation by Eric Young" with version "0.0.0"
    And its address is https://raw.githubusercontent.com/vision5/ngx_devel_kit/refs/heads/master/src/hash/sha.h
    And the pinned versions file has no entry for it
