@domain:container-startup @area:default-config @from:1-17-10/alpine
Feature: Container defaults for nginx 1.17.10 Alpine
  Operators running the image get nginx in the foreground under an init process, workers as an unprivileged user, and timezone control through the environment.

  Background:
    Given the operator runs an nginx-lua 1.17.10 Alpine image

  @id:nginx.container-startup.default-config.001 @rule:startup.default.foreground-nginx-under-init @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#ENTRYPOINT
  Scenario: With no command given, the container runs nginx in the foreground under an init process
    Given the operator gives no command of their own
    When the operator starts the container
    Then the container's first process is dumb-init
    And nginx runs in the foreground with "daemon off;" as its child
    And the default nginx welcome page is served on port 80

  @id:nginx.container-startup.default-config.002 @rule:startup.default.workers-run-as-nginx-user @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#RUN
  Scenario: nginx worker processes run as the unprivileged nginx user
    Given the configuration does not set a user directive
    When the operator starts the container
    Then the nginx worker processes run as user "nginx" with uid 32548
    And they run in group "nginx" with gid 32548

  @id:nginx.container-startup.default-config.003 @rule:startup.default.timezone-from-tz-variable @inferred @source:nginx/1.17.10/alpine/3.12.0/Dockerfile#RUN
  Scenario: The container's local time follows the TZ environment variable
    Given the operator sets TZ to "Europe/Rome"
    When the operator starts the container
    Then local timestamps such as access log times use the Europe/Rome offset
