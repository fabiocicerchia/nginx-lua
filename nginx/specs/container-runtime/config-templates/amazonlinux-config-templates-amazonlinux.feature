@domain:container-runtime @area:config-templates @from:1-27-4/amazonlinux
Feature: Rendering configuration from templates
  Operators configure nginx through environment variables substituted into template files at startup.

  Background:
    Given The container starts with the default nginx command

  @id:nginx.container-runtime.config-templates.529 @rule:config-templates.http-templates-rendered-with-env @inferred @source:nginx/1.27.4/amazonlinux/2023.7.20250331.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are rendered into the nginx configuration directory using environment variables
    Given a template /etc/nginx/templates/site.conf.template referencing ${BACKEND_HOST}
    And BACKEND_HOST is set to app.example.com
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf exists with app.example.com in place of the variable
    And the log says envsubst ran on the template

  @id:nginx.container-runtime.config-templates.530 @rule:config-templates.stream-templates-enable-stream-block @inferred @source:nginx/1.27.4/amazonlinux/2023.7.20250331.0/tpl/20-envsubst-on-templates.sh#add_stream_block
  Scenario: Stream templates are rendered and a stream block is added when missing
    Given a template named tcp.stream-template exists
    And nginx.conf has no stream block
    When the operator starts the container
    Then the rendered file is written under /etc/nginx/stream-conf.d
    And nginx.conf gains a stream block including stream-conf.d/*.conf
