@domain:image-build @area:nginx-compilation @from:1-29-7/fedora
Feature: Refusing tampered upstream sources during the build
  Protects image consumers by failing the build when a downloaded nginx or Lua component does not match its pinned checksum.

  Background:
    Given the Fedora 43 nginx-lua image build

  @id:nginx.image-build.nginx-compilation.006 @rule:image-build.nginx-compilation.checksum-mismatch-fails-build @inferred @source:nginx/1.29.7/fedora/43/tpl/Makefile#secure_download @questionable
  Scenario: A source archive with the wrong checksum fails the build
    Given a pinned SHA256 exists for the nginx 1.29.7 source archive
    And the downloaded archive has a different SHA256
    When the maintainer builds the image
    Then the build prints "FATAL: SHA256 checksum mismatch" with expected and actual values
    And the archive is deleted and the build stops with an error
