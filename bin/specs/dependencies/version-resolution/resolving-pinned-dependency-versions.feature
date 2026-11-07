@domain:dependencies @area:version-resolution @from:bin/generate-deps-env
Feature: Resolving pinned dependency versions
  Gives the maintainer a regenerated dependencies env file (the dist env file under src/) that pins every bundled module to a version and archive checksum that build cleanly together.

  Background:
    Given the dependency manifest lists every bundled module with its repository, whether it tracks a tag or a commit, and its archive URL pattern

  @id:bin.dependencies.version-resolution.001 @rule:dependencies.version-resolution.tag-deps-pin-latest-stable-tag @inferred @source:bin/generate-deps-env.py#get_latest_tag @questionable
  Scenario Outline: A tag-tracked dependency is pinned to its newest non-prerelease tag
    Given the dependency "<dependency>" tracks tags
    And its repository lists the tags <tags>, newest first
    When the maintainer regenerates the dependencies env file
    Then the env file sets VER_<KEY> for "<dependency>" to "<pinned>"
    And tags containing rc, alpha or beta are never chosen
    And a leading "v" is dropped from the pinned version

    Examples:
      | dependency      | tags                         | pinned       |
      | njs             | 0.9.1, 0.9.0                 | 0.9.1        |
      | luajit2         | v2.1-20250826, v2.1-20250117 | 2.1-20250826 |
      | lua-resty-redis | v0.32rc1, v0.31              | 0.31         |

  @id:bin.dependencies.version-resolution.002 @rule:dependencies.version-resolution.commit-deps-pin-latest-commit @inferred @source:bin/generate-deps-env.py#get_latest_commit
  Scenario: A commit-tracked dependency is pinned to the latest commit on its default branch
    Given the dependency "cloudflare_cookie" tracks commits
    And the newest commit on its default branch is 3f1e2d4c5b6a79880123456789abcdef01234567
    When the maintainer regenerates the dependencies env file
    Then the env file sets VER_CLOUDFLARE_COOKIE=3f1e2d4c5b6a79880123456789abcdef01234567

  @id:bin.dependencies.version-resolution.003 @rule:dependencies.version-resolution.resty-core-verified-rc-floor @inferred @source:bin/generate-deps-env.py#main
  Scenario Outline: lua-resty-core uses the verified release candidate until a stable tag catches up
    Given the verified lua-resty-core release candidate is 0.1.34rc2
    And the newest stable lua-resty-core tag is "<stable>"
    When the maintainer regenerates the dependencies env file
    Then the env file sets VER_LUA_RESTY_CORE=<pinned>
    And the run reports "<notice>"

    Examples:
      | stable | pinned    | notice                                                           |
      | 0.1.32 | 0.1.34rc2 | still behind verified RC pin 0.1.34rc2 - using the RC            |
      | 0.1.34 | 0.1.34    | using stable tag 0.1.34 (caught up to verified RC pin 0.1.34rc2) |
      | 0.1.35 | 0.1.35    | using stable tag 0.1.35 (caught up to verified RC pin 0.1.34rc2) |

  @id:bin.dependencies.version-resolution.004 @rule:dependencies.version-resolution.lua-module-matches-resty-core @inferred @source:bin/generate-deps-env.py#get_resty_core_required_lua_module
  Scenario Outline: lua-nginx-module is pinned to the exact version lua-resty-core requires
    Given the pinned lua-resty-core release requires ngx_lua_version <required>
    When the maintainer regenerates the dependencies env file
    Then the env file sets VER_LUA_NGINX_MODULE=<pinned>, even when a newer lua-nginx-module tag exists

    Examples:
      | required | pinned  |
      | 10031    | 0.10.31 |
      | 10029    | 0.10.29 |

  @id:bin.dependencies.version-resolution.005 @rule:dependencies.version-resolution.stream-lua-matches-resty-core @inferred @source:bin/generate-deps-env.py#get_stream_lua_commit_for_api_version @questionable
  Scenario: stream-lua-nginx-module is pinned to the newest commit at the stream API version lua-resty-core requires
    Given the pinned lua-resty-core release requires stream API version 18
    And stream-lua-nginx-module commit c0ffee01 bumped the stream API version to 19, and its parent is commit bead0042
    When the maintainer regenerates the dependencies env file
    Then the env file sets VER_OPENRESTY_STREAMLUA=bead0042
    And the run fails with "Could not find the commit bumping ngx_stream_lua_version to 19" when no such bump commit exists

  @id:bin.dependencies.version-resolution.006 @rule:dependencies.version-resolution.desynced-pair-refused @inferred @source:bin/generate-deps-env.py#main @questionable
  Scenario: A lua-resty-core and lua-nginx-module pair that do not match is refused
    Given the lua-nginx-module version about to be written is not the one the chosen lua-resty-core requires
    When the maintainer regenerates the dependencies env file
    Then the run fails with "version pair desync: lua-resty-core <core> requires lua-nginx-module <required>, but <pinned> is pinned"
    And no env file content is printed

  @id:bin.dependencies.version-resolution.007 @rule:dependencies.version-resolution.archive-checksum-recorded @inferred @source:bin/generate-deps-env.py#compute_sha256 @questionable
  Scenario Outline: Each pinned archive's checksum is recorded, or flagged when it cannot be downloaded
    Given the archive for "<dependency>" at its pinned version <availability>
    When the maintainer regenerates the dependencies env file
    Then the env file sets SHA256_<KEY> for "<dependency>" to <checksum>
    And <warning>
    And the run still completes

    Examples:
      | dependency | availability         | checksum                              | warning                                                         |
      | njs        | downloads            | the SHA-256 of the downloaded archive | no warning is shown                                             |
      | geoip2     | cannot be downloaded | RECOMPUTE_REQUIRED                    | the run warns "Could not download <url> for SHA256 computation" |

  @id:bin.dependencies.version-resolution.008 @rule:dependencies.version-resolution.missing-template-refused @inferred @source:bin/generate-deps-env.py#load_template @questionable
  Scenario: Regeneration is refused when the env file template is missing
    Given the dependencies env template is absent
    When the maintainer regenerates the dependencies env file
    Then the run prints "Error: Template file not found: <path>"
    And the run exits with status 1 before querying any repository
