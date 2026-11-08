@domain:image-build @area:image-layout @from:1-25-4/alpine
Feature: Container log forwarding
  Lets operators read nginx logs with standard container tooling.

  @id:nginx.image-build.image-layout.044 @rule:image.logs.forwarded-to-container-output @inferred @source:nginx/1.25.4/alpine/3.19.1/Dockerfile#Dockerfile
  Scenario: Access and error logs appear in the container's standard output and error
    Given the container is running with the default configuration
    When a client requests http://localhost/
    Then the access log line appears on the container's standard output
    And errors appear on the container's standard error
