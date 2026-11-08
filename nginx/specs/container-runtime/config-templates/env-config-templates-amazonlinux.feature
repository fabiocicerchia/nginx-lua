@domain:container-runtime @area:config-templates @from:1-20-0/amazonlinux
Feature: Rendering configuration from templates
  Operators configure nginx per environment by supplying template files whose environment variable references are filled in at startup.

  Background:
    Given the nginx 1.20.0 Amazon Linux image is started with the default command

  @id:nginx.container-runtime.config-templates.118 @rule:container.templates.render-with-environment-variables @inferred @source:nginx/1.20.0/amazonlinux/2.0.20210421.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are rendered into the configuration directory using environment variables
    Given the environment variable BACKEND_HOST is set to "app.example.com"
    And /etc/nginx/templates/site.conf.template contains "proxy_pass http://${BACKEND_HOST};"
    When the operator starts the container
    Then /etc/nginx/conf.d/site.conf contains "proxy_pass http://app.example.com;"
    And the log says "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-runtime.config-templates.120 @rule:container.templates.unwritable-output-is-reported-not-fatal @inferred @source:nginx/1.20.0/amazonlinux/2.0.20210421.0/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: An unwritable output directory is reported and nothing is rendered
    Given /etc/nginx/templates exists with a template
    And the output directory is not writable
    When the operator starts the container
    Then the log says "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no file is rendered
    And nginx still starts
