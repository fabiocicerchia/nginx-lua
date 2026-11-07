@domain:container-startup @area:default-config @from:1-18-0/centos
Feature: Running nginx with the shipped defaults
  Gives operators a working web server straight from docker run, with workers running under an unprivileged account.

  Background:
    Given the operator runs an nginx-lua 1.18.0 CentOS image without overriding its command or configuration

  @id:nginx.container-startup.default-config.016 @rule:startup.default.serves-on-port-80 @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#CMD
  Scenario: A container started with no arguments serves the default page on port 80
    Given host port 8080 is published to container port 80
    When a client requests http://localhost:8080/
    Then the response status is 200
    And the body is the stock nginx welcome page
    And nginx stays in the foreground as the container's main process

  @id:nginx.container-startup.default-config.017 @rule:startup.default.unprivileged-worker-user @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#RUN
  Scenario: nginx workers run as the unprivileged nginx account
    Given the configuration does not set a user directive
    When nginx starts its worker processes
    Then the workers run as user nginx with uid 32548 and gid 32548
    And the nginx account has no login shell and no home directory
