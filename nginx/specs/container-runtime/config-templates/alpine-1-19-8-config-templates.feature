@domain:container-runtime @area:config-templates @from:1-19-8/alpine
Feature: Configuration from templates
  Operators render nginx configuration from templates using container environment variables.

  Background:
    Given the nginx 1.19.8 Alpine image

  @id:nginx.container-runtime.config-templates.087 @rule:container-runtime.config-templates.render-env-variables @inferred @source:nginx/1.19.8/alpine/3.13.3/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template files are rendered with environment variables into the configuration directory
    Given /etc/nginx/templates/site.conf.template contains "server_name ${SERVER_NAME};"
    And SERVER_NAME is set to www.example.com
    When the operator starts the container with the default command
    Then /etc/nginx/conf.d/site.conf contains "server_name www.example.com;"
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"
