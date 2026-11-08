@domain:platform-support @area:fedora @from:1-23-4/fedora
Feature: Fedora image runtime contract
  Consumers of the Fedora images rely on the published ports, health check, log routing and non-root nginx user.

  Background:
    Given Given the image fabiocicerchia/nginx-lua:1.23.4-fedora37 or -fedora38

  @id:nginx.platform-support.fedora.018 @rule:image.fedora.runtime-contract @inferred @source:nginx/1.23.4/fedora/38/Dockerfile#FROM base
  Scenario: The image exposes web ports, forwards logs to Docker and reports health
    Given a container started from the image
    When the operator inspects and runs the container
    Then ports 80 and 443 are exposed
    And access and error logs go to the container's stdout and stderr
    And the health check requests http://localhost/ every 30 seconds with a 3 second timeout
    And nginx is stopped gracefully with SIGQUIT
    And nginx workers run as the nginx user (uid 101)
