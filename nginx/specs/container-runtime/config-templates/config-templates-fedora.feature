@domain:container-runtime @area:config-templates @from:1-23-2/fedora
Feature: Rendering configuration from templates
  Operators supply nginx configuration as templates with environment variables so one image serves many environments.

  Background:
    Given the nginx-lua image on Fedora is started with the command nginx

  @id:nginx.container-runtime.config-templates.266 @rule:config-templates.envsubst.locations-are-configurable @inferred @source:nginx/1.23.2/fedora/36/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template directory, suffix and output directory can be overridden
    Given templates named *.tpl exist in /custom/in, including one in a subdirectory api/
    And NGINX_ENVSUBST_TEMPLATE_DIR=/custom/in, NGINX_ENVSUBST_TEMPLATE_SUFFIX=.tpl and NGINX_ENVSUBST_OUTPUT_DIR=/custom/out
    When the operator starts the container
    Then rendered files appear under /custom/out without the .tpl suffix
    And the subdirectory api/ is recreated under /custom/out

  @id:nginx.container-runtime.config-templates.267 @rule:config-templates.envsubst.unwritable-output-is-reported-not-fatal @inferred @source:nginx/1.23.2/fedora/36/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: An unwritable output directory is reported and nginx still starts
    Given templates exist in /etc/nginx/templates
    And /etc/nginx/conf.d is read-only
    When the operator starts the container
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no template is rendered
    And nginx still starts
