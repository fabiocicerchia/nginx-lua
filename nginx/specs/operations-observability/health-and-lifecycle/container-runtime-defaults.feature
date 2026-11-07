@domain:operations-observability @area:health-and-lifecycle @from:1-19-4/debian
Feature: Running the container out of the box
  Gives operators a container that serves, reports health, logs and stops cleanly without extra configuration.

  Background:
    Given the operator runs the nginx-lua 1.19.4 Debian 10.6 image with the default command

  @id:nginx.operations-observability.health-and-lifecycle.146 @rule:container.defaults.nginx-user-101 @inferred @source:nginx/1.19.4/debian/10.6/Dockerfile#RUN
  Scenario: nginx worker processes run as the unprivileged nginx user
    Given the image is running
    When the operator inspects the nginx worker processes
    Then they run as user "nginx" with uid 101 and group "nginx" with gid 101
    And the nginx user cannot log in
