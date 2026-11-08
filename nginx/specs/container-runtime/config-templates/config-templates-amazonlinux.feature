@domain:container-runtime @area:config-templates @from:1-19-3/amazonlinux
Feature: Configuration from templates
  Lets an operator generate nginx configuration from environment variables without editing the image.

  Background:
    Given the nginx 1.19.3 Amazon Linux 2.0.20200722.0 image

  @id:nginx.container-runtime.config-templates.021 @rule:config-templates.envsubst.templates-rendered-from-environment @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template files are rendered with environment variables into the config directory
    Given /etc/nginx/templates holds default.conf.template containing "listen ${PORT};"
    And the environment variable PORT is 8080
    When the operator starts the container with the default nginx command
    Then /etc/nginx/conf.d/default.conf contains "listen 8080;"
    And the log shows "Running envsubst on /etc/nginx/templates/default.conf.template to /etc/nginx/conf.d/default.conf"

  @id:nginx.container-runtime.config-templates.022 @rule:config-templates.envsubst.directories-and-suffix-configurable @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template directory, suffix and output directory can be overridden
    Given NGINX_ENVSUBST_TEMPLATE_DIR is /tpl
    And NGINX_ENVSUBST_TEMPLATE_SUFFIX is .tmpl
    And NGINX_ENVSUBST_OUTPUT_DIR is /out
    And /tpl/site.conf.tmpl exists
    When the operator starts the container with the default nginx command
    Then /out/site.conf is created from the template

  @id:nginx.container-runtime.config-templates.023 @rule:config-templates.envsubst.unwritable-output-reported @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: An unwritable output directory is reported and templates are not rendered
    Given /etc/nginx/templates exists
    And the output directory is not writable
    When the operator starts the container with the default nginx command
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no file is rendered
    And nginx still starts
