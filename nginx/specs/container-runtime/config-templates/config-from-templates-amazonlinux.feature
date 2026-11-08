@domain:container-runtime @area:config-templates @from:1-31-4/amazonlinux
Feature: Configuration from environment templates
  Lets an operator generate nginx configuration from template files and environment variables at container start.

  Background:
    Given the nginx-lua image on Amazon Linux 2023

  @id:nginx.container-runtime.config-templates.1058 @rule:runtime.templates.location-suffix-filter-configurable @inferred @source:nginx/1.31.4/amazonlinux/2023.12.20260817.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Template folder, suffix, output folder and variable filter can be overridden
    Given <variable> defaults to <default>
    When the operator starts the container with <variable> set to a custom value
    Then template rendering uses the custom value instead of <default>

    Examples:
      | variable                       | default                |
      | NGINX_ENVSUBST_TEMPLATE_DIR    | /etc/nginx/templates   |
      | NGINX_ENVSUBST_TEMPLATE_SUFFIX | .template              |
      | NGINX_ENVSUBST_OUTPUT_DIR      | /etc/nginx/conf.d      |
      | NGINX_ENVSUBST_FILTER          | (empty, all variables) |
