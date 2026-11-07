@domain:distribution @area:amazon-linux-images @from:1-17-10/amazonlinux
Feature: Running nginx 1.17.10 with Lua on Amazon Linux
  Gives operators who standardise on Amazon Linux a ready-to-run nginx 1.17.10 image with Lua scripting, published for several Amazon Linux base releases.

  Background:
    Given Given the operator has pulled a fabiocicerchia/nginx-lua 1.17.10 Amazon Linux image

  @id:nginx.distribution.amazon-linux-images.001 @rule:distribution.amazon-linux.tag-matches-base-release @inferred @source:nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile#LABEL
  Scenario Outline: Each 1.17.10 Amazon Linux tag runs nginx 1.17.10 on the Amazon Linux release named in the tag
    Given the image tag is "<tag>"
    When the operator inspects the image
    Then the image description reads "Nginx 1.17.10 with LUA support based on amazonlinux <base>."
    And the suggested run command is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:<tag>"

    Examples:
      | tag                                     | base                 |
      | 1.17.10-amazonlinux2.0.20180622.1       | 2.0.20180622.1       |
      | 1.17.10-amazonlinux2.0.20180827         | 2.0.20180827         |
      | 1.17.10-amazonlinux2.0.20181010         | 2.0.20181010         |
      | 1.17.10-amazonlinux2.0.20200406.0       | 2.0.20200406.0       |
      | 1.17.10-amazonlinux2018.03.0.20200318.1 | 2018.03.0.20200318.1 |

  @id:nginx.distribution.amazon-linux-images.002 @rule:distribution.amazon-linux.lua-in-http-config @inferred @source:nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile#RUN
  Scenario: Lua code in the HTTP configuration runs out of the box
    Given the operator's configuration answers "/hello" with Lua code that prints "hello from lua"
    When a client requests "/hello"
    Then the response status is 200
    And the response body is "hello from lua"

  @id:nginx.distribution.amazon-linux-images.003 @rule:distribution.amazon-linux.default-run-serves-http @inferred @source:nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile#HEALTHCHECK
  Scenario: A container started with no arguments serves HTTP on port 80 and reports healthy
    Given the operator has not supplied any configuration or command
    When the operator starts a container from the image
    Then nginx runs in the foreground as the container's main process
    And a request to http://localhost/ inside the container answers with a success status
    And the container health status becomes "healthy"
    And ports 80 and 443 are declared as exposed

  @id:nginx.distribution.amazon-linux-images.004 @rule:distribution.amazon-linux.logs-to-container-output @inferred @source:nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile#RUN
  Scenario: Access and error logs appear in the container's output
    Given the container is running with the default log locations
    When a client requests "/"
    Then the access log line for the request appears on the container's standard output
    And nginx error messages appear on the container's standard error

  @id:nginx.distribution.amazon-linux-images.005 @rule:distribution.amazon-linux.workers-run-unprivileged @inferred @source:nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile#RUN
  Scenario: Request-handling workers run as the unprivileged nginx user
    Given the container is running with the default configuration
    When the operator lists the container's processes
    Then the worker processes run as user "nginx" with uid 32548 and gid 32548
    And the nginx user has no login shell and no home directory

  @id:nginx.distribution.amazon-linux-images.006 @rule:distribution.amazon-linux.stop-is-fast-shutdown @inferred @source:nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile#STOPSIGNAL @questionable
  Scenario: Stopping the container shuts nginx down immediately rather than draining requests
    Given a client request is in progress
    When the operator stops the container
    Then nginx receives SIGTERM and exits without waiting for the in-progress request to finish

  @id:nginx.distribution.amazon-linux-images.007 @rule:distribution.amazon-linux.amd64-only @inferred @source:nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile#ENTRYPOINT @questionable
  Scenario: The 1.17.10 Amazon Linux images only start on amd64 hosts
    Given the operator runs the image on an arm64 host
    When the operator starts a container from the image
    Then the container fails to start because its init process is an x86_64 binary
