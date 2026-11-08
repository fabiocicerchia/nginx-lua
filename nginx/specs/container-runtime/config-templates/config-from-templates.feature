@domain:container-runtime @area:config-templates @from:1-21-4/alpine
Feature: Rendering configuration from environment variables
  Lets operators generate nginx configuration from templates filled with container environment variables.

  Background:
    Given Given the nginx-lua image based on Alpine 3.15.0 with nginx 1.21.4

  @id:nginx.container-runtime.config-templates.160 @rule:container-runtime.config-templates.render-from-env @inferred @source:nginx/1.21.4/alpine/3.15.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template files are rendered into the configuration directory
    Given the file "/etc/nginx/templates/site.conf.template" contains "server_name ${SERVER_HOST};"
    And the environment variable SERVER_HOST is "www.example.com"
    When the operator starts the container with the default nginx command
    Then "/etc/nginx/conf.d/site.conf" contains "server_name www.example.com;"
    And the log says "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-runtime.config-templates.161 @rule:container-runtime.config-templates.unwritable-output-warns @inferred @source:nginx/1.21.4/alpine/3.15.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are not rendered when the output directory is read-only
    Given the templates directory exists
    And the configuration output directory is not writable
    When the operator starts the container with the default nginx command
    Then the log says "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no file is generated
    And nginx still starts
