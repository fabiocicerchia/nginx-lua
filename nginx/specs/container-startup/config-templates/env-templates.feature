@domain:container-startup @area:config-templates @from:1-19-10/amazonlinux
Feature: Rendering configuration templates from environment variables
  Lets operators set up nginx through environment variables by rendering *.template files into the config folder when the container starts.

  Background:
    Given the operator runs the nginx-lua 1.19.10 Amazon Linux 2 image with its default command

  @id:nginx.container-startup.config-templates.005 @rule:container-startup.templates.render-defined-variables @inferred @source:nginx/1.19.10/amazonlinux/2.0.20210326.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: A template is rendered into conf.d with only the environment variables that are set replaced
    Given /etc/nginx/templates/site.conf.template contains "server_name ${SERVER_NAME}; return 200 $host${UNSET_VAR};"
    And SERVER_NAME is set to "www.example.com"
    And UNSET_VAR is not set
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf contains "server_name www.example.com; return 200 $host${UNSET_VAR};"
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-startup.config-templates.006 @rule:container-startup.templates.subfolders-preserved @inferred @source:nginx/1.19.10/amazonlinux/2.0.20210326.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates in subfolders are rendered into the same subfolders of the output folder
    Given /etc/nginx/templates/sites/api.conf.template exists
    When the operator starts the container
    Then /etc/nginx/conf.d/sites/api.conf is created from it

  @id:nginx.container-startup.config-templates.007 @rule:container-startup.templates.custom-locations @inferred @source:nginx/1.19.10/amazonlinux/2.0.20210326.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: The template folder, suffix and output folder can be changed through environment variables
    Given NGINX_ENVSUBST_TEMPLATE_DIR is "/srv/tpl"
    And NGINX_ENVSUBST_TEMPLATE_SUFFIX is ".tmpl"
    And NGINX_ENVSUBST_OUTPUT_DIR is "/etc/nginx/sites"
    And /srv/tpl contains "app.conf.tmpl" and "other.conf.template"
    When the operator starts the container
    Then /etc/nginx/sites/app.conf is created
    And no file is rendered from "other.conf.template"

  @id:nginx.container-startup.config-templates.008 @rule:container-startup.templates.unwritable-output-reported @inferred @source:nginx/1.19.10/amazonlinux/2.0.20210326.0/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: Templates are not rendered when the output folder is not writable, and nginx still starts
    Given /etc/nginx/templates contains "site.conf.template"
    And /etc/nginx/conf.d is mounted read-only
    When the operator starts the container
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no file is rendered
    And nginx starts with the existing configuration
