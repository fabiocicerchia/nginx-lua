@domain:container-startup @area:config-templates @from:1-19-3/ubuntu
Feature: Rendering config templates from environment variables
  Lets operators keep nginx config as templates and fill in values from container environment variables at startup.

  Background:
    Given Given the operator runs the nginx 1.19.3 Ubuntu 20.04 image with the default command

  @id:nginx.container-startup.config-templates.035 @rule:container.templates.render-defined-variables-only @inferred @source:nginx/1.19.3/ubuntu/20.04/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: Templates are rendered with only the environment variables that are defined
    Given /etc/nginx/templates/sites/app.conf.template contains "server_name ${SERVER_NAME}; set $x $host; root ${UNSET_VAR};"
    And the environment variable SERVER_NAME is "app.example.com"
    And UNSET_VAR is not defined
    And /etc/nginx/conf.d exists and is writable
    When the container starts
    Then /etc/nginx/conf.d/sites/app.conf contains "server_name app.example.com; set $x $host; root ${UNSET_VAR};"
    And the log shows "Running envsubst on /etc/nginx/templates/sites/app.conf.template to /etc/nginx/conf.d/sites/app.conf"

  @id:nginx.container-startup.config-templates.037 @rule:container.templates.unwritable-output-is-reported @inferred @source:nginx/1.19.3/ubuntu/20.04/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: Templates are not rendered when the output folder is not writable
    Given /etc/nginx/templates contains "default.conf.template"
    And /etc/nginx/conf.d is missing or read-only
    When the container starts
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no template is rendered
    And nginx still starts

  @id:nginx.container-startup.config-templates.038 @rule:container.templates.no-template-folder-no-op @inferred @source:nginx/1.19.3/ubuntu/20.04/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Without a template folder nothing is rendered
    Given /etc/nginx/templates does not exist
    When the container starts
    Then no config file is written
    And no template error is logged
    And nginx starts
