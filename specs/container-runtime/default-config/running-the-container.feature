@domain:container-runtime @area:default-config @from:nginx-lua/dockerfile
Feature: Running the nginx-lua container
  Gives operators an image that runs nginx in the foreground on the standard web ports, reports its health, logs to the container streams and stops gracefully.

  Background:
    Given the operator has the fabiocicerchia/nginx-lua image

  @id:container-runtime.default-config.001 @rule:container-runtime.defaults.foreground-nginx-on-web-ports @inferred @source:Dockerfile#CMD
  Scenario: A started container runs nginx in the foreground on ports 80 and 443
    Given no command override is given
    When the operator starts a container from the image
    Then the container runs "nginx -g 'daemon off;'" through /docker-entrypoint.sh
    And the image declares ports 80 and 443
    And the container keeps running while nginx runs

  @id:container-runtime.default-config.002 @rule:observability.health-checks.http-probe-on-localhost @inferred @source:Dockerfile#HEALTHCHECK @questionable
  Scenario: The container reports unhealthy when nginx stops answering on port 80
    Given a running container
    When the container runtime probes http://localhost/ every 30 seconds
    Then the container is healthy while the probe gets a successful response within 3 seconds
    And the container is unhealthy when the probe gets an error status or no answer within 3 seconds

  @id:container-runtime.default-config.003 @rule:container-runtime.process-lifecycle.graceful-stop @inferred @source:Dockerfile#STOPSIGNAL
  Scenario: Stopping the container lets nginx finish in-flight requests
    Given a running container serving requests
    When the operator stops the container
    Then nginx receives SIGQUIT instead of SIGTERM
    And nginx shuts down gracefully

  @id:container-runtime.default-config.004 @rule:container-runtime.process-lifecycle.nginx-user-owns-files @inferred @source:Dockerfile#base @questionable
  Scenario: nginx config, cache and binaries belong to the unprivileged nginx user
    Given a container from the image
    When the operator inspects the shipped files
    Then an nginx user and group with id 101 exist, with no login shell
    And /etc/nginx, /var/cache/nginx, the Lua libraries and the nginx binaries are owned by 101:101
    And nginx worker processes run as user nginx by default
