@domain:image-build @area:image-layout @from:1-29-4/fedora
Feature: Default container behaviour of the image
  Gives operators a container that runs nginx in the foreground, logs to the container log collector and reports its health.

  Background:
    Given Given the nginx-lua Fedora 43 image for nginx 1.29.4

  @id:nginx.image-build.image-layout.064 @rule:image.defaults.nginx-foreground-on-web-ports @inferred @source:nginx/1.29.4/fedora/43/Dockerfile#CMD
  Scenario: The container runs nginx in the foreground and advertises web ports
    Given no command override
    When the operator starts the container
    Then the container process is "nginx -g 'daemon off;'"
    And ports 80 and 443 are declared
    And a stop request sends SIGQUIT for a graceful shutdown

  @id:nginx.image-build.image-layout.065 @rule:image.defaults.logs-go-to-container-log @inferred @source:nginx/1.29.4/fedora/43/Dockerfile#RUN
  Scenario: Access and error logs appear in the container log
    Given the container is running with the default configuration
    When a client requests the default page
    Then the access log entry appears on the container's standard output
    And nginx errors appear on the container's standard error

  @id:nginx.image-build.image-layout.066 @rule:image.defaults.health-reported-by-http-probe @inferred @source:nginx/1.29.4/fedora/43/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container is reported unhealthy when the root page fails
    Given the container is running
    When the container runtime runs its health check
    Then the container is healthy when http://localhost/ answers with a success status
    And the container is unhealthy after the request fails or exceeds 3 seconds
