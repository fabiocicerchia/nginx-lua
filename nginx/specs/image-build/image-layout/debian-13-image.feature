@domain:image-build @area:image-layout @from:1-29-1/debian
Feature: Debian 13 image contents
  Users pulling the Debian 13.x tag get nginx with Lua running unprivileged, logging to the container log and reporting health.

  @id:nginx.image-build.image-layout.060 @rule:image-build.image-layout.health-and-ports @inferred @source:nginx/1.29.1/debian/13.1/Dockerfile
  Scenario: The container exposes ports 80 and 443 and reports health from the default page
    Given the Debian 13 image is running
    When the container runtime checks health every 30 seconds
    Then the container is healthy while http://localhost/ answers successfully
    And the container is unhealthy when it does not answer within 3 seconds

  @id:nginx.image-build.image-layout.061 @rule:image-build.image-layout.graceful-stop-signal @inferred @source:nginx/1.29.1/debian/13.1/Dockerfile
  Scenario: Stopping the container shuts nginx down gracefully
    Given the Debian 13 image is running
    When the operator stops the container
    Then nginx receives SIGQUIT and finishes in-flight requests before exiting
