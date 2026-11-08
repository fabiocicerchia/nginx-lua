@domain:image-build @area:image-layout @from:1-31-4/almalinux
Feature: Image runtime contract
  Defines what operators can rely on when running the published AlmaLinux image: ports, logs, shutdown and health.

  Background:
    Given Given the AlmaLinux 10.2 nginx-lua image

  @id:nginx.image-build.image-layout.087 @rule:image-build.image-layout.graceful-stop-and-ports @inferred @source:nginx/1.31.4/almalinux/10.2-20260602/Dockerfile#STOPSIGNAL
  Scenario: The container stops gracefully and exposes ports 80 and 443
    When the operator stops the container
    Then nginx receives SIGQUIT and finishes in-flight requests
    And ports 80 and 443 are declared

  @id:nginx.image-build.image-layout.088 @rule:image-build.image-layout.health-check-needs-curl @inferred @source:nginx/1.31.4/almalinux/10.2-20260602/Dockerfile#HEALTHCHECK @questionable
  Scenario: Container health is judged by fetching the root page with curl
    When the container runtime runs the health check
    Then the container is healthy when http://localhost/ answers with a success status
    And the container is unhealthy otherwise
