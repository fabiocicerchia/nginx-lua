@domain:container-runtime @area:config-templates @from:1-25-2/alpine
Feature: Configuration from templates
  Operators supply nginx config templates with variable placeholders that are rendered at container start.

  Background:
    Given Given the nginx 1.25.2 Alpine image

  @id:nginx.container-runtime.config-templates.346 @rule:templates.render.output-dir-not-writable @inferred @source:nginx/1.25.2/alpine/3.18.4/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: Templates are not rendered when the output directory is not writable
    Given a templates directory exists
    And the conf directory is not writable
    When the operator starts the container
    Then the log reads "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no file is rendered
    And nginx still starts

  @id:nginx.container-runtime.config-templates.347 @rule:templates.render.stream-templates-enable-stream-block @inferred @source:nginx/1.25.2/alpine/3.18.4/tpl/20-envsubst-on-templates.sh#add_stream_block
  Scenario: Stream templates are rendered and a stream block is added to the main configuration
    Given a template tcp.conf.stream-template exists
    And the main configuration has no stream block
    When the operator starts the container
    Then the rendered file is written to /etc/nginx/stream-conf.d/tcp.conf
    And a stream block including /etc/nginx/stream-conf.d/*.conf is appended to nginx.conf
