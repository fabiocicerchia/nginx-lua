@domain:container-startup @area:default-config @from:1-19-3/alpine
Feature: Default runtime setup
  Tells operators which user nginx runs as, and which binaries and default command they get, so volume permissions and troubleshooting work as expected.

  @id:nginx.container-startup.default-config.041 @rule:container.default-config.nginx-user-ids @inferred @source:nginx/1.19.3/alpine/3.12.1/Dockerfile#RUN @questionable
  Scenario Outline: nginx worker processes run as the nginx user with a fixed id
    Given the operator uses the nginx 1.19.3 image on Alpine <os>
    When the operator starts the container with the default command
    Then nginx runs in the foreground
    And worker processes run as user nginx with uid and gid <id>

    Examples:
      | os     | id    |
      | 3.12.1 | 101   |
      | 3.12.0 | 101   |
      | 3.11.6 | 32548 |

  @id:nginx.container-startup.default-config.042 @rule:web-server.debug-binary.available @inferred @source:nginx/1.19.3/alpine/3.12.1/tpl/Makefile#core
  Scenario: A debug build of nginx is available alongside the release build
    Given the operator uses the nginx 1.19.3 image on Alpine 3.12.1
    When the operator starts the container with the command nginx-debug -g 'daemon off;'
    Then the start-up hooks run
    And nginx with debug logging support serves requests
