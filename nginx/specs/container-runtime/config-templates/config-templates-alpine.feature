@domain:container-runtime @area:config-templates @from:1-30-3/alpine
Feature: Rendering configuration from templates
  Lets operators generate nginx configuration from template files using environment variables.

  Background:
    Given Given the nginx-lua Alpine image 1.30.3
    And Given the template directory is /etc/nginx/templates

  @id:nginx.container-runtime.config-templates.889 @rule:container-runtime.config-templates.render-with-env @inferred @source:nginx/1.30.3/alpine/3.24.1/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template files are rendered into the conf.d directory with environment values
    Given a template default.conf.template containing "listen ${PORT};"
    And PORT is 8080
    When the operator starts the container with the command nginx
    Then /etc/nginx/conf.d/default.conf contains "listen 8080;"
    And the log shows "Running envsubst on" the template and its output path
