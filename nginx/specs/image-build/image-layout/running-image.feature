@domain:image-build @area:image-layout @from:1-31-4/fedora
Feature: Running the Fedora image
  Gives operators a container whose logs, health and Lua interpreter behave predictably.

  Background:
    Given the image fabiocicerchia/nginx-lua:1.31.4-fedora44

  @id:nginx.image-build.image-layout.092 @rule:image.health.unhealthy-when-port-80-fails @inferred @source:nginx/1.31.4/fedora/44/Dockerfile#HEALTHCHECK
  Scenario: The container reports unhealthy when http://localhost/ does not respond successfully
    Given the container is running
    When the container platform runs the health check every 30 seconds
    Then a successful HTTP response on port 80 marks it healthy
    And a failure or no response within 3 seconds marks the check failed
