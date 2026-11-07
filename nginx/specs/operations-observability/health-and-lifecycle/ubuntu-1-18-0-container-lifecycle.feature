@domain:operations-observability @area:health-and-lifecycle @from:1-18-0/ubuntu
Feature: Running the nginx 1.18.0 Ubuntu container
  Operators who run the nginx 1.18.0 Ubuntu images need to know what the container serves out of the box, how it reports health, where its logs go and how it stops.

  Background:
    Given the operator runs an nginx 1.18.0 Ubuntu image (18.04, 19.10, 20.04 or 20.10) with no configuration of their own

  @id:nginx.operations-observability.health-and-lifecycle.033 @rule:image.health.healthcheck-probes-default-site @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#HEALTHCHECK @questionable
  Scenario: The built-in healthcheck marks the container unhealthy because its probe tool is missing
    Given the container has been running for more than 90 seconds
    And nginx answers requests on port 80
    When the container runtime runs the image's healthcheck
    Then the probe command "curl" is not found in the image
    And each probe fails, and after 3 failed probes the container is reported as "unhealthy"

  @id:nginx.operations-observability.health-and-lifecycle.034 @rule:image.default-site.welcome-page-on-port-80 @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#RUN @questionable
  Scenario: A fresh container serves the stock nginx welcome page on port 80 only
    Given the operator publishes ports 80 and 443
    When a client requests "/" on port 80
    Then the response is 200 with the stock "Welcome to nginx!" page
    And a request for a missing path returns 404
    And nothing listens on port 443, although the image declares it as exposed

  @id:nginx.operations-observability.health-and-lifecycle.035 @rule:image.logging.logs-to-container-output @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#RUN
  Scenario: Access and error logs appear on the container's output
    Given the container is serving traffic
    When a client requests "/missing.html"
    Then an access log line for "GET /missing.html" with status 404 appears on the container's stdout
    And the matching "No such file or directory" error line appears on the container's stderr

  @id:nginx.operations-observability.health-and-lifecycle.036 @rule:image.lifecycle.stop-is-fast-shutdown @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container shuts nginx down at once instead of draining requests
    Given a client download is in progress
    When the operator stops the container
    Then nginx receives SIGTERM through dumb-init and exits at once
    And the in-progress download is cut off rather than finished

  @id:nginx.operations-observability.health-and-lifecycle.037 @rule:image.runtime.workers-run-as-nginx-user @inferred @source:nginx/1.18.0/ubuntu/20.04/Dockerfile#RUN
  Scenario: nginx workers run as the unprivileged nginx user with a fixed uid and gid
    Given the operator mounts a content directory that is readable by uid 32548
    When the container starts
    Then the nginx worker processes run as user "nginx" (uid 32548) in group "nginx" (gid 32548)
    And the nginx user has no login shell and no home directory
