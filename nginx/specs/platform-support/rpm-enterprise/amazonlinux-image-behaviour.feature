@domain:platform-support @area:rpm-enterprise @from:1-29-6/amazonlinux
Feature: Amazon Linux image runtime contract
  Gives operators the ports, logging, health and shutdown behaviour of the Amazon Linux image.

  Background:
    Given Given the amazonlinux nginx-lua image for nginx 1.29.6

  @id:nginx.platform-support.rpm-enterprise.028 @rule:image.shutdown.graceful-on-stop @inferred @source:nginx/1.29.6/amazonlinux/2023.10.20260216.1/Dockerfile#STOPSIGNAL
  Scenario: Stopping the container shuts nginx down gracefully
    Given the container is running with active connections
    When the operator stops the container
    Then nginx receives SIGQUIT and finishes in-flight requests before exiting
