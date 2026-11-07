@domain:container-startup @area:default-config @from:1-19-0/debian
Feature: Default runtime of nginx 1.19.0 Debian containers
  Operators who start the image without overrides get nginx in the foreground on the standard web ports, running as a fixed unprivileged user, with timezone support.

  Background:
    Given an operator runs a container from an nginx 1.19.0 Debian slim image

  @id:nginx.container-startup.default-config.021 @rule:default-config.run.nginx-foreground-under-init @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#ENTRYPOINT
  Scenario: Without a command, the container runs nginx in the foreground under a minimal init
    Given the operator passes no command
    When the operator starts the container
    Then dumb-init runs as the container's main process
    And nginx runs with "daemon off;" so the container stays up while nginx runs

  @id:nginx.container-startup.default-config.022 @rule:default-config.ports.http-and-https-exposed @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#EXPOSE
  Scenario: The image publishes the HTTP and HTTPS ports
    When the operator inspects the image
    Then ports 80 and 443 are listed as exposed

  @id:nginx.container-startup.default-config.023 @rule:default-config.user.fixed-nginx-identity @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#adduser
  Scenario: nginx workers run as the unprivileged nginx user with a fixed ID
    When the operator starts the container
    Then nginx worker processes run as user nginx in group nginx
    And the nginx user and group both have ID 32548
    And the nginx user has no login shell and no home directory

  @id:nginx.container-startup.default-config.024 @rule:default-config.timezone.settable-by-environment @inferred @source:nginx/1.19.0/debian/10.4-slim/Dockerfile#tzdata
  Scenario: The operator can set the container timezone through the environment
    Given the operator sets TZ=Europe/Rome
    When the operator starts the container
    Then times nginx writes, such as log timestamps, are in the Europe/Rome timezone
