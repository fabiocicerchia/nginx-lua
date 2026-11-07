@domain:container-startup @area:default-config @from:1-19-10/ubuntu
Feature: Default runtime configuration
  Defines what the container does out of the box: how nginx is launched, which user it runs as and how operators set the time zone.

  Background:
    Given the operator runs the nginx-lua 1.19.10 Ubuntu 20.04 image

  @id:nginx.container-startup.default-config.033 @rule:container.default-config.foreground-nginx @inferred @source:nginx/1.19.10/ubuntu/20.04/Dockerfile#CMD
  Scenario: With no command given, the container runs nginx in the foreground
    When the operator starts the container without a command
    Then the container runs "nginx -g 'daemon off;'" after the startup scripts
    And the container stays running for as long as nginx runs

  @id:nginx.container-startup.default-config.035 @rule:container.default-config.timezone-from-env @inferred @source:nginx/1.19.10/ubuntu/20.04/Dockerfile#RUN
  Scenario: The container's time zone can be set through the TZ environment variable
    Given the environment variable TZ is "Europe/Rome"
    When the operator starts the container
    Then local times in the container, including those in nginx logs, use the Europe/Rome time zone
