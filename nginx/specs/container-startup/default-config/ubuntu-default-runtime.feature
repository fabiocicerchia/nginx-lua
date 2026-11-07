@domain:container-startup @area:default-config @from:1-19-2/ubuntu
Feature: Running nginx with the shipped defaults
  Operators who run the Ubuntu image without arguments get nginx in the foreground under a minimal init, with worker processes under a fixed unprivileged account and a configurable timezone.

  Background:
    Given Given a container started from the nginx-lua 1.19.2 Ubuntu image

  @id:nginx.container-startup.default-config.040 @rule:container.defaults.timezone-from-env @inferred @source:nginx/1.19.2/ubuntu/20.04/Dockerfile#RUN
  Scenario: The operator can set the container timezone through an environment variable
    Given the operator starts the container with TZ=Europe/Rome
    When nginx writes a log line with a timestamp
    Then the timestamp is in Europe/Rome local time
