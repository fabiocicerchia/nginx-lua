@domain:container-runtime @area:config-templates @from:1-31-7/fedora
Feature: Configuration from environment-variable templates
  Operators render nginx configuration from templates using container environment variables.

  Background:
    Given Given the nginx-lua Fedora 44 image for nginx 1.31.7

  @id:nginx.container-runtime.config-templates.1132 @rule:runtime.templates.customisable-locations @inferred @source:nginx/1.31.7/fedora/44/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Template location, suffix and output folder can be overridden
    Given NGINX_ENVSUBST_TEMPLATE_DIR, NGINX_ENVSUBST_TEMPLATE_SUFFIX and NGINX_ENVSUBST_OUTPUT_DIR are set to <dir>, <suffix> and <out>
    When the operator starts the container with the default command
    Then files in <dir> ending in <suffix> are rendered into <out> without the suffix

    Examples:
      | dir                  | suffix   | out               |
      | /tpl                 | .tmpl    | /etc/nginx/conf.d |
      | /etc/nginx/templates | .conf.in | /tmp/out          |
