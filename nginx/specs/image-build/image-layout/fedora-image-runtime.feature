@domain:image-build @area:image-layout @from:1-31-8/fedora
Feature: Fedora image runtime defaults
  Gives operators a container that logs to Docker, reports its health and stops gracefully.

  Background:
    Given Given the Fedora 44 or 45 nginx-lua image

  @id:nginx.image-build.image-layout.096 @rule:image.layout.logs-and-health-exposed-to-docker @inferred @source:nginx/1.31.8/fedora/44/Dockerfile#final stage
  Scenario: Logs go to the container log and health is checked over HTTP
    Given the container is running
    When the operator inspects the container's logs and health
    Then access log output appears on stdout and error log output on stderr
    And ports 80 and 443 are exposed
    And health is reported by requesting http://localhost/ every 30 seconds with a 3 second timeout
    And docker stop sends SIGQUIT for graceful shutdown
