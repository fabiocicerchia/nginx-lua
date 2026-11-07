@domain:container-startup @area:config-templates @from:1-19-3/alpine
Feature: Rendering configuration templates from environment variables
  Lets operators keep nginx configuration as templates and fill in values from the container environment at start-up.

  Background:
    Given the container image nginx 1.19.3 on Alpine 3.12.1
    And the container is started with the default nginx command

  @id:nginx.container-startup.config-templates.020 @rule:container.config-templates.render-defined-variables-only @inferred @source:nginx/1.19.3/alpine/3.12.1/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are rendered with defined environment variables while undefined ones such as nginx variables are left untouched
    Given the template /etc/nginx/templates/site.conf.template contains "server_name ${SERVER_NAME}; return 200 $host;"
    And the environment variable SERVER_NAME is example.com
    And no environment variable named host is defined
    And the folder /etc/nginx/conf.d exists and is writable
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf contains "server_name example.com; return 200 $host;"
    And the start-up log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-startup.config-templates.021 @rule:container.config-templates.locations-configurable @inferred @source:nginx/1.19.3/alpine/3.12.1/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Template folder, template suffix and output folder can be changed through environment variables
    Given the environment variable <variable> is <value>
    And a template exists in the configured template folder with the configured suffix
    When the operator starts the container
    Then the rendered file is written to the configured output folder without the suffix

    Examples:
      | variable                       | value               |
      | NGINX_ENVSUBST_TEMPLATE_DIR    | /srv/templates      |
      | NGINX_ENVSUBST_TEMPLATE_SUFFIX | .tpl                |
      | NGINX_ENVSUBST_OUTPUT_DIR      | /etc/nginx/stream.d |
