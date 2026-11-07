@domain:container-startup @area:entrypoint-hooks @from:1-19-3/debian
Feature: Running startup hooks before nginx starts
  Operators of the nginx 1.19.3 Debian images can drop shell scripts into /docker-entrypoint.d to configure the container before nginx launches, without rebuilding the image.

  Background:
    Given an nginx-lua 1.19.3 container built from the debian 10.6, 10.6-slim or 10.5-slim image

  @id:nginx.container-startup.entrypoint-hooks.001 @rule:container.startup-hooks.not-in-debian-10-4-slim @inferred @source:nginx/1.19.3/debian/10.4-slim/Dockerfile#ENTRYPOINT @questionable
  Scenario: The Debian 10.4-slim image starts nginx without startup hooks
    Given an nginx-lua 1.19.3 container built from the debian 10.4-slim image
    And /docker-entrypoint.d contains the executable script "15-certs.sh"
    When the operator starts the container with the default command
    Then "15-certs.sh" does not run
    And nginx starts under dumb-init
