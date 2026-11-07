@domain:container-startup @area:default-config @from:1-17-10/centos
Feature: Running the CentOS nginx 1.17.10 container
  Gives operators a container that starts nginx in the foreground as an unprivileged user with sensible defaults.

  Background:
    Given the operator has pulled a CentOS nginx 1.17.10 image

  @id:nginx.container-startup.default-config.004 @rule:container.default-run.foreground-nginx @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#CMD
  Scenario: Starting the container with no command serves the default site on port 80
    Given no command override is given
    When the operator starts the container publishing port 80
    Then nginx runs in the foreground as the container's main process under dumb-init
    And GET http://localhost/ returns the nginx welcome page with status 200

  @id:nginx.container-startup.default-config.005 @rule:container.default-run.unprivileged-nginx-user @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#RUN
  Scenario: nginx workers run as the nginx user with fixed UID and GID 32548
    Given the container is running with the default configuration
    When the operator lists the container's processes
    Then the worker processes run as user nginx with UID 32548 and GID 32548
    And the nginx user has no login shell

  @id:nginx.container-startup.default-config.006 @rule:container.default-run.timezone-from-env @inferred @source:nginx/1.17.10/centos/8.2.2004/Dockerfile#RUN
  Scenario: The operator can set the container's timezone with TZ
    Given the operator sets TZ to Europe/Rome
    When the operator starts the container
    Then times in the nginx logs are shown in Europe/Rome local time
