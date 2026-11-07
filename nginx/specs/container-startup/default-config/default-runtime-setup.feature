@domain:container-startup @area:default-config @from:1-19-3/amazonlinux
Feature: Default runtime user and log output
  Gives operators predictable file ownership and container-native logs in the Amazon Linux images.

  Background:
    Given a container is running from the nginx 1.19.3 Amazon Linux image

  @id:nginx.container-startup.default-config.043 @rule:container.default-config.nginx-system-user @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/Dockerfile#NGINX_BUILD_CONFIG
  Scenario: nginx workers run as the nginx user with uid and gid 101
    Given the operator's config sets no "user" directive
    When nginx starts its worker processes
    Then the workers run as user "nginx" with uid 101 and gid 101
    And the nginx user has no login shell and no home directory

  @id:nginx.container-startup.default-config.044 @rule:operations.logging.forward-to-container-output @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's output
    Given nginx logs to its default access and error log files
    When a client requests http://localhost/missing
    Then the access log line for the request appears on the container's stdout
    And error messages appear on the container's stderr
