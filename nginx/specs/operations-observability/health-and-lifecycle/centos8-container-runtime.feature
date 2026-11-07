@domain:operations-observability @area:health-and-lifecycle @from:1-19-4/centos
Feature: Running the nginx 1.19.4 CentOS 8 container
  Operators running the CentOS 8 image need predictable ports, health reporting, logging, process identity and shutdown so it fits their orchestrator.

  Background:
    Given the operator runs the nginx 1.19.4 CentOS 8 image with its default command

  @id:nginx.operations-observability.health-and-lifecycle.137 @rule:image.lifecycle.default-command-runs-nginx-in-foreground @inferred @source:nginx/1.19.4/centos/8/Dockerfile#CMD
  Scenario: The container runs nginx in the foreground by default
    Given no command override is given
    When the operator starts the container
    Then the startup hooks in /docker-entrypoint.d run first
    And nginx starts with "daemon off;" as the container's main process
    And the container keeps running for as long as nginx runs

  @id:nginx.operations-observability.health-and-lifecycle.138 @rule:image.ports.http-and-https-exposed @inferred @source:nginx/1.19.4/centos/8/Dockerfile#EXPOSE
  Scenario: The image publishes the HTTP and HTTPS ports
    Given the container is running
    When the operator inspects the image's exposed ports
    Then port 80 is listed
    And port 443 is listed
    And no other port is listed

  @id:nginx.operations-observability.health-and-lifecycle.139 @rule:image.health.root-url-probe @inferred @source:nginx/1.19.4/centos/8/Dockerfile#HEALTHCHECK
  Scenario Outline: The container is healthy only while the local site answers without error
    Given the container is running
    When the container runtime runs the health check
    Then it requests http://localhost/ every 30 seconds
    And a response with status <status> marks the check as <result>
    And no answer within 3 seconds marks the check as failed

    Examples:
      | status | result |
      | 200    | passed |
      | 301    | passed |
      | 404    | failed |
      | 502    | failed |

  @id:nginx.operations-observability.health-and-lifecycle.142 @rule:image.runtime.nginx-user-uid-101 @inferred @source:nginx/1.19.4/centos/8/Dockerfile#RUN
  Scenario: nginx workers run as the unprivileged nginx user with uid and gid 101
    Given the configuration does not override the worker user
    When the operator starts the container
    Then worker processes run as user "nginx" with uid 101 and group "nginx" with gid 101
    And the nginx user has no login shell and no home directory
