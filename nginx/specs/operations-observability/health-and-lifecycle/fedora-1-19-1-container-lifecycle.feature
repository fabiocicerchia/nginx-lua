@domain:operations-observability @area:health-and-lifecycle @from:1-19-1/fedora
Feature: Container health, ports and shutdown
  Lets operators and orchestrators know whether the nginx container is serving and stop it without dropping in-flight requests.

  Background:
    Given a container is running from the image 1.19.1-fedora32

  @id:nginx.operations-observability.health-and-lifecycle.067 @rule:operations.lifecycle.healthcheck-probes-local-http @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#HEALTHCHECK
  Scenario: The container is reported unhealthy when nginx stops answering on port 80
    Given nginx no longer answers HTTP requests on http://localhost/
    When the container runtime runs the built-in health check
    Then the check fails if no successful response arrives within 3 seconds
    And the runtime repeats the check every 30 seconds
    And the container is marked unhealthy after the consecutive failures the runtime requires

  @id:nginx.operations-observability.health-and-lifecycle.068 @rule:operations.lifecycle.graceful-stop-on-container-stop @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets nginx finish in-flight requests
    Given nginx is serving a long-running request
    When the operator stops the container
    Then nginx receives SIGQUIT through dumb-init
    And nginx finishes the in-flight request before exiting

  @id:nginx.operations-observability.health-and-lifecycle.069 @rule:operations.lifecycle.exposed-http-https-ports @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#EXPOSE
  Scenario: The image advertises HTTP and HTTPS ports
    When the operator inspects the image
    Then ports 80 and 443 are listed as exposed
