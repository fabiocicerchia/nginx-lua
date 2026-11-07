@domain:documentation @area:changelog @from:bin/generate-changelog
Feature: Generating release changelogs
  Gives the maintainer release notes for a new nginx-lua tag: the commits since the last tag, a compare link and the supported versions, ready to paste into a GitHub release.

  Background:
    Given the nginx-lua repository has a previous release tag "v1.31.7"
    And the supported versions list names nginx_mainline=1.31.8, nginx_stable=1.30.6 and alpine=3.24.3

  @id:bin.documentation.changelog.001 @rule:docs.changelog.requires-three-arguments @inferred @source:bin/generate-changelog.sh#parse_arguments
  Scenario Outline: The changelog is refused unless a GitHub user, previous tag and new tag are all given
    Given the maintainer supplies the arguments <arguments>
    When the maintainer generates the changelog
    Then the error "<message>" is shown
    And the hint "Use 'generate-changelog.sh --help' for usage information" is shown
    And the command exits with status 1 and no changelog is printed

    Examples:
      | arguments                            | message                            |
      | fabiocicerchia v1.31.7               | Error: Expected 3 arguments, got 2 |
      | fabiocicerchia v1.31.7 v1.31.8 extra | Error: Expected 3 arguments, got 4 |
      | "" v1.31.7 v1.31.8                   | Error: Missing required arguments  |

  @id:bin.documentation.changelog.002 @rule:docs.changelog.help @inferred @source:bin/generate-changelog.sh#show_help
  Scenario: Asking for help shows usage without generating a changelog
    Given the maintainer passes "--help" among any other arguments
    When the maintainer generates the changelog
    Then the usage "Usage: generate-changelog.sh [OPTIONS] <gh_username> <previous_tag> <tag_ver>" is shown with the three arguments described
    And the command exits with status 0 and no changelog is printed

  @id:bin.documentation.changelog.003 @rule:docs.changelog.lists-commits-since-previous-tag @inferred @source:bin/generate-changelog.sh#main
  Scenario: The changelog lists each distinct commit message since the previous tag, with a compare link
    Given the commits since "v1.31.7" are "Fix: PCRE2 for RPM", "Fix: PCRE2 for RPM" and "Bump certifi"
    When the maintainer generates the changelog for user "fabiocicerchia" from "v1.31.7" to "v1.31.8"
    Then the output starts with the heading "## What's Changed"
    And the list shows " - fix: pcre2 for rpm" once and " - bump certifi", all in lower case
    And the line "**Full Changelog**: https://github.com/fabiocicerchia/nginx-lua/compare/v1.31.7...v1.31.8" follows the list
    And the file CHANGELOG holds the same list

  @id:bin.documentation.changelog.004 @rule:docs.changelog.excludes-automated-commits @inferred @source:bin/generate-changelog.sh#main @questionable
  Scenario: Automated update commits still appear in the changelog
    Given the commits since "v1.31.7" include "Automated updates (#436)" and "Fix: PCRE2 for RPM"
    When the maintainer generates the changelog for user "fabiocicerchia" from "v1.31.7" to "v1.31.8"
    Then the list shows " - automated updates (#436)"
    And the list shows " - fix: pcre2 for rpm"

  @id:bin.documentation.changelog.005 @rule:docs.changelog.commit-list-printed-twice @inferred @source:bin/generate-changelog.sh#main @questionable
  Scenario: The commit list is printed twice in the changelog output
    Given the commits since "v1.31.7" are "Bump certifi"
    When the maintainer generates the changelog for user "fabiocicerchia" from "v1.31.7" to "v1.31.8"
    Then under "## What's Changed" the raw list appears first and the cleaned list " - bump certifi" appears right after it
    And only the cleaned list is kept in the file CHANGELOG

  @id:bin.documentation.changelog.006 @rule:docs.changelog.lists-supported-versions @inferred @source:bin/generate-changelog.sh#main
  Scenario: The changelog ends with the supported nginx and distribution versions
    When the maintainer generates the changelog for user "fabiocicerchia" from "v1.31.7" to "v1.31.8"
    Then the heading "## Supported Versions" follows the compare link
    And each supported version shows as a bullet, e.g. " - nginx_mainline=1.31.8", " - nginx_stable=1.30.6", " - alpine=3.24.3", in lower case with brackets and quotes removed
