@domain:image-build @area:image-layout @from:1-19-6/ubuntu
Feature: Running the nginx-lua container image
  Serves operators who run the nginx 1.19.6 with Lua image on Ubuntu 20.04 and expect logs, health status and shutdown to behave well under Docker.

  Background:
    Given Given the operator has the image fabiocicerchia/nginx-lua:1.19.6-ubuntu20.04

  @id:nginx.image-build.image-layout.004 @rule:image.health.reports-unhealthy-when-root-not-served @inferred @source:nginx/1.19.6/ubuntu/20.04/Dockerfile#HEALTHCHECK @questionable
  Scenario: The container reports unhealthy when the site does not answer
    Given a running nginx-lua container
    When Docker runs the periodic health check against http://localhost/
    Then the container is healthy when the request returns a success status
    And the container is unhealthy when the request fails or returns an error status

  @id:nginx.image-build.image-layout.005 @rule:image.shutdown.graceful-quit-on-stop @inferred @source:nginx/1.19.6/ubuntu/20.04/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets in-flight requests finish
    Given a running nginx-lua container handling a request
    When the operator stops the container
    Then nginx receives SIGQUIT and finishes in-flight requests before exiting
