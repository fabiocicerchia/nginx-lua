@domain:container-runtime @area:entrypoint @from:1-25-0/alpine
Feature: Starting the container with startup hooks
  Operators who mount or bake scripts into /docker-entrypoint.d rely on them running in order before nginx starts.

  Background:
    Given Given the nginx-lua Alpine 3.18.0 image for nginx 1.25.0

  @id:nginx.container-runtime.entrypoint.039 @rule:container.entrypoint.quiet-logs @inferred @source:nginx/1.25.0/alpine/3.18.0/tpl/docker-entrypoint.sh#entrypoint_log
  Scenario: Quiet mode silences startup hook messages
    Given NGINX_ENTRYPOINT_QUIET_LOGS is set
    When the operator starts the container with the command nginx
    Then no entrypoint or hook info messages are printed
