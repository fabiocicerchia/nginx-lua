@domain:container-runtime @area:config-templates @from:1-29-2/alpine
Feature: Rendering configuration from templates
  Operators supply nginx configuration as templates that are filled from environment variables at container start.

  Background:
    Given the nginx-lua Alpine image started with the nginx command

  @id:nginx.container-runtime.config-templates.700 @rule:config.templates.rendered-from-environment @inferred @source:nginx/1.29.2/alpine/3.22.2/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template files are rendered into the nginx configuration directory
    Given /etc/nginx/templates/site.conf.template contains "server_name ${SERVER_NAME};"
    And SERVER_NAME is set to www.example.com
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf contains "server_name www.example.com;"
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-runtime.config-templates.702 @rule:config.templates.stream-templates-enable-stream-block @inferred @source:nginx/1.29.2/alpine/3.22.2/tpl/20-envsubst-on-templates.sh#add_stream_block
  Scenario: Stream templates are rendered and wired into nginx.conf
    Given /etc/nginx/templates/tcp.conf.stream-template exists
    And nginx.conf has no stream block
    When the operator starts the container
    Then /etc/nginx/stream-conf.d/tcp.conf is created
    And nginx.conf gains a stream block including /etc/nginx/stream-conf.d/*.conf
