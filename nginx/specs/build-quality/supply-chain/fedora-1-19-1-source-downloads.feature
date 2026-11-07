@domain:build-quality @area:supply-chain @from:1-19-1/fedora
Feature: Trusting the downloaded sources
  Tells maintainers and security reviewers whether sources fetched while building the image are checked before they are compiled in.

  @id:nginx.build-quality.supply-chain.001 @rule:build.supply-chain.downloads-checksum-verified @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#builder @questionable
  Scenario: Sources for the Fedora 1.19.1 images are compiled without any checksum check
    Given a source archive served for nginx or a bundled module has been altered but is still a valid archive
    When the maintainer builds the image 1.19.1-fedora32
    Then the build succeeds
    And the altered source is compiled into the image
