@domain:operations-observability @area:logging @from:1-19-1/fedora
Feature: Logs on the container's output
  Lets operators collect nginx access and error logs with the container runtime's standard log tooling.

  @id:nginx.operations-observability.logging.005 @rule:operations.logging.access-and-error-logs-to-container-output @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#NGINX_BUILD_CONFIG
  Scenario: Access logs go to stdout and error logs go to stderr
    Given a container is running from the image 1.19.1-fedora32 with the default log paths
    When a client requests a page that does not exist
    Then the access log line for the request appears on the container's stdout
    And the error message for the missing file appears on the container's stderr
