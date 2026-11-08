@domain:release-lines @area:base-os-refresh @from:1-28-1/amazonlinux
Feature: Amazon Linux base refresh
  Users pick an nginx 1.28.1 image on a specific Amazon Linux 2023 point release.

  @id:nginx.release-lines.base-os-refresh.005 @rule:release-lines.base-os-refresh.os-version-labelled @inferred @source:nginx/1.28.1/amazonlinux/2023.10.20260120.4/Dockerfile#LABEL
  Scenario Outline: Each Amazon Linux 2023 rebuild states its base OS version in its image labels
    Given images exist for Amazon Linux 2023.10.20260105.0 and 2023.10.20260120.4
    When the operator inspects the image labels
    Then versions.os is the matching point release
    And the version label is 1.28.1-amazonlinux<point release>
    And the suggested run command exposes port 80

    Examples:
      | point release      |
      | 2023.10.20260105.0 |
      | 2023.10.20260120.4 |
