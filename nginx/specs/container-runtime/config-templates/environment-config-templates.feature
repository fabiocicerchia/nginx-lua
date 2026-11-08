@domain:container-runtime @area:config-templates @from:1-19-4/ubuntu
Feature: Configuration from environment templates
  Lets an operator generate nginx configuration files from templates using container environment variables.

  Background:
    Given Given the nginx-lua 1.19.4 Ubuntu 20.04 image

  @id:nginx.container-runtime.config-templates.046 @rule:runtime.templates.render-env-into-conf-d @inferred @source:nginx/1.19.4/ubuntu/20.04/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are rendered with environment values into the nginx config directory
    Given /etc/nginx/templates/site.conf.template contains "listen ${PORT};"
    And the environment variable PORT is 8080
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf contains "listen 8080;"
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-runtime.config-templates.047 @rule:runtime.templates.directories-suffix-overridable @inferred @source:nginx/1.19.4/ubuntu/20.04/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template folder, suffix and output folder can be overridden and subfolders are preserved
    Given NGINX_ENVSUBST_TEMPLATE_DIR is /tpl, NGINX_ENVSUBST_TEMPLATE_SUFFIX is .tmpl and NGINX_ENVSUBST_OUTPUT_DIR is /out
    And /tpl/sub/a.conf.tmpl exists
    When the operator starts the container
    Then /out/sub/a.conf is created
    And the .tmpl suffix is removed from the output name

  @id:nginx.container-runtime.config-templates.048 @rule:runtime.templates.unwritable-output-is-reported @inferred @source:nginx/1.19.4/ubuntu/20.04/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: Templates are not rendered when the output folder is not writable
    Given /etc/nginx/templates exists
    And /etc/nginx/conf.d is read-only
    When the operator starts the container
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no file is rendered
    And nginx still starts
