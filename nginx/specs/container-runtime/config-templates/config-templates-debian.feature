@domain:container-runtime @area:config-templates @from:1-30-2/debian
Feature: Rendering configuration from templates
  Lets operators ship nginx configuration as templates filled with container environment variables.

  Background:
    Given the nginx-lua Debian 13.5 image with templates folder /etc/nginx/templates and output folder /etc/nginx/conf.d

  @id:nginx.container-runtime.config-templates.873 @rule:runtime.templates.locations-are-configurable @inferred @source:nginx/1.30.2/debian/13.5/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Template folder, suffix and output folder can be changed by environment variables
    Given <variable> is set to <value>
    When the operator starts the container with the command nginx
    Then <effect>

    Examples:
      | variable                       | value            | effect                                         |
      | NGINX_ENVSUBST_TEMPLATE_DIR    | /opt/tpl         | templates are read from /opt/tpl               |
      | NGINX_ENVSUBST_TEMPLATE_SUFFIX | .tmpl            | only files ending in .tmpl are rendered        |
      | NGINX_ENVSUBST_OUTPUT_DIR      | /etc/nginx/extra | rendered files are written to /etc/nginx/extra |
