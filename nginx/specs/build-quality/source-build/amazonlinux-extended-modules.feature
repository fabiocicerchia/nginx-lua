@domain:build-quality @area:source-build @from:1-19-2/amazonlinux
Feature: Extended module set in Amazon Linux images
  Users of the extended image expect header manipulation and TCP/UDP Lua scripting to be available in nginx.

  Background:
    Given the image was built with EXTENDED_IMAGE=1

  @id:nginx.build-quality.source-build.003 @rule:build.extended-image.extended-modules-compiled @inferred @source:nginx/1.19.2/amazonlinux/2.0.20200722.0/Dockerfile#RUN @questionable
  Scenario Outline: The extended image includes headers-more and stream Lua, but silently drops them if the extended configure fails
    Given the nginx configure step with the headers-more and stream-lua modules <outcome>
    When the operator runs "nginx -V" in the finished image
    Then the configure arguments <list> --add-module entries for headers-more-nginx-module and stream-lua-nginx-module
    And the image label versions.extended is still "1"

    Examples:
      | outcome  | list           |
      | succeeds | include        |
      | fails    | do not include |
