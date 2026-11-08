@domain:container-runtime @area:config-templates @from:1-31-6/almalinux
Feature: Configuration templating from environment variables
  Lets an operator render nginx configuration files from templates using container environment variables.

  Background:
    Given the nginx-lua AlmaLinux image started with the default nginx command

  @id:nginx.container-runtime.config-templates.1094 @rule:runtime.templates.render-with-env @inferred @source:nginx/1.31.6/almalinux/10.2-20260902/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are rendered into the configuration directory with environment values
    Given /etc/nginx/templates/site.conf.template contains "listen ${PORT};"
    And PORT is set to 8080
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf contains "listen 8080;"
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-runtime.config-templates.1095 @rule:runtime.templates.only-defined-variables @inferred @source:nginx/1.31.6/almalinux/10.2-20260902/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Only variables defined in the environment are substituted, so nginx variables survive
    Given a template contains "return 200 $request_uri ${GREETING};"
    And GREETING is set to hello and request_uri is not an environment variable
    When the operator starts the container
    Then the rendered file contains "return 200 $request_uri hello;"
