@domain:image-build @area:image-layout @from:1-30-5/ubuntu
Feature: Image logging and health reporting
  Lets operators collect nginx logs with the container runtime and see whether the web server is serving.

  @id:nginx.image-build.image-layout.080 @rule:image-build.image-layout.container-reported-unhealthy-when-root-fails @inferred @source:nginx/1.30.5/ubuntu/26.04/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when the root page cannot be fetched
    Given a running container from the image
    When the container runtime runs its health check and http://localhost/ returns an error or no response within 3 seconds
    Then the container's health status becomes unhealthy after repeated failures
    And checks run every 30 seconds
