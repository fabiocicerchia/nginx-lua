@domain:container-runtime @area:config-templates @from:1-19-10/alpine
Feature: Rendering configuration from templates
  Lets operators generate nginx configuration from variables set at container start without building a custom image.

  Background:
    Given Given the nginx-lua alpine image 1.19.10-alpine3.13.5

  @id:nginx.container-runtime.config-templates.001 @rule:templates.render.variables-into-conf @inferred @source:nginx/1.19.10/alpine/3.13.5/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template files are rendered into the nginx configuration directory
    Given the file /etc/nginx/templates/site.conf.template contains "server_name ${SERVER_NAME};"
    And the variable SERVER_NAME is example.com
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf contains "server_name example.com;"
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-runtime.config-templates.002 @rule:templates.render.only-defined-variables-substituted @inferred @source:nginx/1.19.10/alpine/3.13.5/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Variables that are not set are left as written
    Given the template contains "return 200 $uri ${SERVER_NAME};"
    And the variable SERVER_NAME is example.com and no variable named uri is set
    When the operator starts the container
    Then the rendered file contains "return 200 $uri example.com;"

  @id:nginx.container-runtime.config-templates.003 @rule:templates.render.directories-and-suffix-configurable @inferred @source:nginx/1.19.10/alpine/3.13.5/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template directory, suffix and output directory can be overridden
    Given NGINX_ENVSUBST_TEMPLATE_DIR is /srv/tpl, NGINX_ENVSUBST_TEMPLATE_SUFFIX is .tmpl and NGINX_ENVSUBST_OUTPUT_DIR is /srv/out
    And /srv/tpl/a/b.conf.tmpl exists
    When the operator starts the container
    Then /srv/out/a/b.conf.tmpl is not created
    And /srv/out/a/b.conf is created from the template

  @id:nginx.container-runtime.config-templates.004 @rule:templates.render.unwritable-output-is-refused @inferred @source:nginx/1.19.10/alpine/3.13.5/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: Rendering is skipped with an error message when the output directory is not writable
    Given the templates directory exists
    And the output directory is read-only
    When the operator starts the container
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no file is rendered
    And the container still starts
