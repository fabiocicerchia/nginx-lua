@domain:release-docs @area:changelog @from:bin/generate-changelog
Feature: Generating release notes
  Lets a release manager produce markdown release notes (changes, compare link, supported versions) for a new tag.

  Background:
    Given The release manager runs bin/generate-changelog.sh with a GitHub username, the previous tag and the new tag from a clone of the repository

  @id:bin.release-docs.changelog.001 @rule:release-docs.changelog.usage-help @inferred @source:bin/generate-changelog.sh#show_help
  Scenario: Help describes the changelog command
    When the release manager asks the changelog command for help
    Then the usage line shows gh_username, previous_tag and tag_ver
    And the command exits with status 0

  @id:bin.release-docs.changelog.002 @rule:release-docs.changelog.requires-three-arguments @inferred @source:bin/generate-changelog.sh#parse_arguments
  Scenario Outline: The changelog command refuses missing or extra arguments
    When the release manager runs the changelog command with <count> arguments
    Then the command prints "Error: Expected 3 arguments, got <count>"
    And the command exits with status 1
    And no changelog is produced

    Examples:
      | count |
      | 0     |
      | 2     |
      | 4     |

  @id:bin.release-docs.changelog.003 @rule:release-docs.changelog.lists-commits-since-previous-tag @inferred @source:bin/generate-changelog.sh#main @questionable
  Scenario: Release notes list every commit message since the previous tag
    Given commits "Fix: rotate keys" and "Add http3 support" exist after tag 1.2.0
    When the release manager generates the changelog for tag 1.3.0 from previous tag 1.2.0
    Then the output starts with "## What's Changed"
    And the output lists " - fix: rotate keys" and " - add http3 support" in lower case
    And repeated lines are shown once

  @id:bin.release-docs.changelog.004 @rule:release-docs.changelog.excludes-automated-commits @inferred @source:bin/generate-changelog.sh#main @questionable
  Scenario: Automated update commits are meant to be left out of the release notes
    Given a commit "Automated updates (#436)" exists after the previous tag
    When the release manager generates the changelog
    Then the filtered change list is meant to omit "Automated updates" and "Automated metadata" commits
    And the filtered list still shows " - automated updates (#436)"

  @id:bin.release-docs.changelog.005 @rule:release-docs.changelog.compare-link @inferred @source:bin/generate-changelog.sh#main
  Scenario: Release notes link to the full comparison between tags
    When the release manager generates the changelog for user fabiocicerchia from tag 1.2.0 to tag 1.3.0
    Then the output contains "**Full Changelog**: https://github.com/fabiocicerchia/nginx-lua/compare/1.2.0...1.3.0"

  @id:bin.release-docs.changelog.006 @rule:release-docs.changelog.lists-supported-versions @inferred @source:bin/generate-changelog.sh#main
  Scenario: Release notes end with the supported versions
    Given the supported versions list contains the line ("nginx 1.27.0" "Debian 12")
    When the release manager generates the changelog
    Then the output ends with a "## Supported Versions" section
    And the section shows " - nginx 1.27.0 debian 12" in lower case without parentheses or quotes
