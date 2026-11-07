@domain:operations-observability @area:health-and-lifecycle @from:1-19-2/fedora
Feature: Running the Fedora nginx 1.19.2 container
  Operators running the Fedora image need its health signal, ports, shutdown behaviour and logs to work with standard container tooling.

  Background:
    Given a container started from the Fedora nginx 1.19.2 image with the default command

  @id:nginx.operations-observability.health-and-lifecycle.103 @rule:lifecycle.fedora.healthcheck-probes-local-http @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#HEALTHCHECK
  Scenario Outline: The container reports unhealthy when nginx stops answering on port 80
    Given nginx answers http://localhost/ with <response>
    When the container runtime runs the built-in health check
    Then the container is reported <health>

    Examples:
      | response                  | health    |
      | 200 OK within 3 seconds   | healthy   |
      | 404 Not Found             | unhealthy |
      | no reply within 3 seconds | unhealthy |

  @id:nginx.operations-observability.health-and-lifecycle.104 @rule:lifecycle.fedora.graceful-stop-on-sigquit @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets nginx finish in-flight requests
    Given a client request is in progress
    When the operator stops the container
    Then nginx receives SIGQUIT through dumb-init
    And the in-flight request completes before nginx exits

  @id:nginx.operations-observability.health-and-lifecycle.105 @rule:lifecycle.fedora.exposes-http-and-https-ports @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#EXPOSE
  Scenario: The image advertises HTTP and HTTPS ports
    When the operator inspects the image configuration
    Then ports 80/tcp and 443/tcp are listed as exposed

  @id:nginx.operations-observability.health-and-lifecycle.106 @rule:logging.fedora.logs-go-to-container-output @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#base
  Scenario: Access and error logs appear in the container's output
    Given a client requests http://localhost/missing.html
    When the operator reads the container logs
    Then the access log line for /missing.html appears on stdout
    And the error log line for the missing file appears on stderr

  @id:nginx.operations-observability.health-and-lifecycle.107 @rule:lifecycle.fedora.timezone-from-environment @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#base
  Scenario: The container clock follows the TZ environment variable
    Given the container is started with TZ set to "Europe/Rome"
    When the operator reads the local time inside the container
    Then the time is shown in the Europe/Rome timezone
