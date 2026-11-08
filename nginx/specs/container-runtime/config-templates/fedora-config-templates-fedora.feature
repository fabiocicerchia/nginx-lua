@domain:container-runtime @area:config-templates @from:1-31-8/fedora
Feature: Rendering configuration from templates
  Lets operators supply nginx configuration with environment variables substituted at container start.

  Background:
    Given the Fedora 44 or 45 nginx-lua image

  @id:nginx.container-runtime.config-templates.1153 @rule:runtime.templates.variables-substituted-into-config @inferred @source:nginx/1.31.8/fedora/44/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Environment variables are substituted into template files at start-up
    Given the templates directory holds site.conf.template containing ${BACKEND_HOST}
    And the environment sets BACKEND_HOST to app.example.com
    When the operator starts the container with the default nginx command
    Then /etc/nginx/conf.d/site.conf exists with app.example.com in place of ${BACKEND_HOST}
    And the log shows "Running envsubst on" the template and its output path

  @id:nginx.container-runtime.config-templates.1155 @rule:runtime.templates.stream-templates-enabled-via-stream-block @inferred @source:nginx/1.31.8/fedora/44/tpl/20-envsubst-on-templates.sh#add_stream_block
  Scenario: Stream templates are rendered and a stream block is added when none exists
    Given the templates directory holds proxy.conf.stream-template
    And nginx.conf has no stream block
    When the operator starts the container with the default nginx command
    Then the rendered file appears in /etc/nginx/stream-conf.d/proxy.conf
    And nginx.conf gains a stream block including /etc/nginx/stream-conf.d/*.conf
