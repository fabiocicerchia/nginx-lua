@domain:dependencies @area:build-environment @from:bin/generate-deps-env
Feature: Generating the pinned dependency environment
  Serves maintainers and the nightly update job by producing the environment file of upstream versions and SHA256 checksums that image builds consume.

  Background:
    Given The generator queries GitHub for the latest upstream versions and prints the environment file to standard output; progress and warnings go to standard error.

  @id:bin.dependencies.build-environment.001 @rule:dependencies.build-environment.resty-core-lua-module-pair-consistent @inferred @source:bin/generate-deps-env.py#get_resty_core_required_lua_module
  Scenario: The Lua module version always matches what lua-resty-core requires
    Given lua-resty-core 0.1.34rc2 requires ngx_lua_version 10031 in its base.lua
    When the maintainer generates the dependency environment file
    Then the file pins lua-nginx-module to 0.10.31
    And the file pins lua-resty-core to 0.1.34rc2
    And the progress output says lua-resty-core 0.1.34rc2 pins lua-nginx-module to 0.10.31

  @id:bin.dependencies.build-environment.002 @rule:dependencies.build-environment.resty-core-rc-floor @inferred @source:bin/generate-deps-env.py#main
  Scenario Outline: A verified release candidate is kept until a stable lua-resty-core release catches up
    Given the verified lua-resty-core pin is 0.1.34rc2
    And the latest stable lua-resty-core tag is <latest_stable>
    When the maintainer generates the dependency environment file
    Then the file pins lua-resty-core to <pinned>

    Examples:
      | latest_stable | pinned    |
      | 0.1.32        | 0.1.34rc2 |
      | 0.1.34        | 0.1.34    |
      | 0.1.35        | 0.1.35    |

  @id:bin.dependencies.build-environment.003 @rule:dependencies.build-environment.stream-lua-commit-matches-resty-core @inferred @source:bin/generate-deps-env.py#get_stream_lua_commit_for_api_version
  Scenario: The stream Lua module is pinned to the commit lua-resty-core requires
    Given lua-resty-core requires stream API version 18
    When the maintainer generates the dependency environment file
    Then the stream Lua module is pinned to the commit just before the one that bumps the API version to 19
    And the run fails if no commit bumping the API to 19 is found

  @id:bin.dependencies.build-environment.004 @rule:dependencies.build-environment.other-deps-track-latest @inferred @source:bin/generate-deps-env.py#get_latest_tag
  Scenario: Other dependencies are pinned to their latest stable tag or newest commit
    Given a dependency is tracked by release tag and its newest tags are 1.2.4rc1 and v1.2.3
    When the maintainer generates the dependency environment file
    Then the file pins that dependency to 1.2.3
    And dependencies tracked by commit are pinned to the newest default-branch commit

  @id:bin.dependencies.build-environment.005 @rule:dependencies.build-environment.checksum-per-dependency @inferred @source:bin/generate-deps-env.py#compute_sha256 @questionable
  Scenario: Every dependency gets a SHA256 checksum of its source archive, or a recompute marker
    Given a dependency archive cannot be downloaded
    When the maintainer generates the dependency environment file
    Then a warning naming the URL is written to standard error
    And that dependency's checksum is RECOMPUTE_REQUIRED
    And other dependencies keep their real SHA256 digests

  @id:bin.dependencies.build-environment.006 @rule:dependencies.build-environment.generation-fails-without-output-on-upstream-error @inferred @source:bin/generate-deps-env.py#main
  Scenario: Generation stops without printing a file when upstream data cannot be resolved
    Given GitHub returns an error when resolving versions
    When the maintainer generates the dependency environment file
    Then the run exits with an error
    And no environment file is printed
