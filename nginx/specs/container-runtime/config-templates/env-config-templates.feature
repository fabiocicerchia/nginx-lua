@domain:container-runtime @area:config-templates @from:1-19-10/debian
Feature: Rendering configuration from templates
  Operators supply environment variables and get nginx configuration files generated from templates at startup.

  Background:
    Given Given the nginx-lua 1.19.10 Debian 10.9 image

  @id:nginx.container-runtime.config-templates.008 @rule:container.templates.render-env-into-config @inferred @source:nginx/1.19.10/debian/10.9/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template files are rendered into the configuration folder with environment values
    Given /etc/nginx/templates/site.conf.template contains "listen ${PORT};"
    And the environment variable PORT is 8080
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf contains "listen 8080;"
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-runtime.config-templates.009 @rule:container.templates.locations-configurable @inferred @source:nginx/1.19.10/debian/10.9/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template folder, suffix and output folder can be changed by the operator
    Given NGINX_ENVSUBST_TEMPLATE_DIR is /opt/tpl
    And NGINX_ENVSUBST_TEMPLATE_SUFFIX is .tmpl
    And NGINX_ENVSUBST_OUTPUT_DIR is /etc/nginx/extra
    And /opt/tpl/a.conf.tmpl exists
    When the operator starts the container
    Then /etc/nginx/extra/a.conf is generated

  @id:nginx.container-runtime.config-templates.010 @rule:container.templates.unwritable-output-reported @inferred @source:nginx/1.19.10/debian/10.9/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: Rendering is skipped with an error when the output folder is not writable
    Given the templates folder exists
    And the output folder is not writable
    When the operator starts the container
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no file is generated
    And the container still starts
