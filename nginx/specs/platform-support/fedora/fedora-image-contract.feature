@domain:platform-support @area:fedora @from:1-19-2/fedora
Feature: Running nginx with Lua on Fedora images
  Operators who deploy the Fedora 32, 33 and 34 images need a container that serves HTTP, logs to Docker, reports health and stops gracefully.

  Background:
    Given Given the nginx 1.19.2 Lua image built on Fedora <fedora_release>

  @id:nginx.platform-support.fedora.014 @rule:image.runtime.serves-http-and-https-ports @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#EXPOSE
  Scenario: The container advertises HTTP and HTTPS ports and starts nginx in the foreground
    Given a container started from the image with no command override
    When the operator starts the container
    Then ports 80 and 443 are exposed
    And nginx runs in the foreground as the container's main process

  @id:nginx.platform-support.fedora.015 @rule:image.runtime.reports-health-by-home-page @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the home page does not answer
    Given a running container
    When the orchestrator runs the health check every 30 seconds
    Then the container is healthy while http://localhost/ answers with a success status
    And the container is unhealthy when the request fails or takes over 3 seconds

  @id:nginx.platform-support.fedora.016 @rule:image.runtime.stops-gracefully @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets in-flight requests finish
    Given a running container handling requests
    When the operator stops the container
    Then nginx receives a quit signal and finishes active requests before exiting

  @id:nginx.platform-support.fedora.017 @rule:image.lua.upstream-module-from-fedora-33 @inferred @source:nginx/1.19.2/fedora/33/Dockerfile#LABEL @questionable
  Scenario Outline: Lua upstream inspection is available on Fedora 33 and 34 but not on Fedora 32
    Given the image release is <fedora_release>
    When the operator inspects the image's reported component versions
    Then the lua-upstream version is <upstream_version>

    Examples:
      | fedora_release | upstream_version |
      | 32             | not listed       |
      | 33             | 0.07             |
      | 34             | 0.07             |
