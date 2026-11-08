@domain:auto-configuration @area:template-substitution @from:src/20-envsubst-on-templates
Feature: Rendering nginx config from environment-based templates
  Lets an operator ship config templates and have container environment variables filled in at startup, so one image serves many environments.

  Background:
    Given Given the container starts with the default template, suffix and output settings

  @id:src.auto-configuration.template-substitution.001 @rule:autoconfig.templates.render-with-environment @inferred @source:src/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are rendered with environment variables into live config
    Given a template "default.conf.template" in /etc/nginx/templates containing "listen ${NGINX_PORT};"
    And the environment variable NGINX_PORT is "8080"
    When the operator starts the container
    Then the file /etc/nginx/conf.d/default.conf exists with "listen 8080;"
    And the startup output says "Running envsubst on /etc/nginx/templates/default.conf.template to /etc/nginx/conf.d/default.conf"

  @id:src.auto-configuration.template-substitution.002 @rule:autoconfig.templates.only-defined-variables-substituted @inferred @source:src/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Only defined variables are substituted; nginx variables are left intact
    Given a template containing "proxy_set_header Host $host; server_name ${SERVER_NAME};"
    And the environment variable SERVER_NAME is "example.com"
    And no environment variable named "host" is defined
    When the operator starts the container
    Then the rendered file contains "proxy_set_header Host $host; server_name example.com;"

  @id:src.auto-configuration.template-substitution.003 @rule:autoconfig.templates.filter-limits-substitution @inferred @source:src/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: A filter limits which variables may be substituted
    Given a template containing "${APP_HOST} ${SECRET_TOKEN}"
    And the environment variables APP_HOST is "app.example.com" and SECRET_TOKEN is "abc"
    And NGINX_ENVSUBST_FILTER is "^APP_"
    When the operator starts the container
    Then the rendered file contains "app.example.com ${SECRET_TOKEN}"

  @id:src.auto-configuration.template-substitution.004 @rule:autoconfig.templates.stream-templates-enable-stream-block @inferred @source:src/20-envsubst-on-templates.sh#add_stream_block
  Scenario: Stream templates are rendered and wired into nginx.conf
    Given a template "tcp.conf.stream-template" in the templates directory
    And nginx.conf has no stream block and is writable
    When the operator starts the container
    Then the file /etc/nginx/stream-conf.d/tcp.conf is rendered
    And nginx.conf gains a stream block including "/etc/nginx/stream-conf.d/*.conf"

  @id:src.auto-configuration.template-substitution.005 @rule:autoconfig.templates.unwritable-output-does-not-block-startup @inferred @source:src/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: An unwritable output directory is reported but does not stop startup
    Given templates exist in /etc/nginx/templates
    And /etc/nginx/conf.d is not writable
    When the operator starts the container
    Then the startup output says "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no template is rendered
    And the startup continues with exit status 0
