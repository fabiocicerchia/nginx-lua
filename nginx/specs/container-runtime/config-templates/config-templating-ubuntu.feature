@domain:container-runtime @area:config-templates @from:1-31-1/ubuntu
Feature: Rendering configuration from templates
  Operators supply nginx config templates with environment variables that are filled in at container start.

  Background:
    Given Given the nginx-lua Ubuntu 26.04 image

  @id:nginx.container-runtime.config-templates.1020 @rule:runtime.templates.render-env-variables @inferred @source:nginx/1.31.1/ubuntu/26.04/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are rendered into configuration files using environment variables
    Given a template /etc/nginx/templates/site.conf.template containing ${BACKEND_HOST}
    And BACKEND_HOST is set to app.example.com
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf exists with app.example.com in place of ${BACKEND_HOST}
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-runtime.config-templates.1021 @rule:runtime.templates.paths-and-filter-configurable @inferred @source:nginx/1.31.1/ubuntu/26.04/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Template locations, suffixes and substituted variables can be configured
    Given templates exist in a custom directory
    When the operator starts the container with a custom template directory, suffix, output directory or variable filter
    Then templates in the custom directory with the custom suffix are rendered into the custom output directory
    And only variables whose names match NGINX_ENVSUBST_FILTER are substituted

    Examples:
      | setting                        | default                |
      | NGINX_ENVSUBST_TEMPLATE_DIR    | /etc/nginx/templates   |
      | NGINX_ENVSUBST_TEMPLATE_SUFFIX | .template              |
      | NGINX_ENVSUBST_OUTPUT_DIR      | /etc/nginx/conf.d      |
      | NGINX_ENVSUBST_FILTER          | (empty: all variables) |
