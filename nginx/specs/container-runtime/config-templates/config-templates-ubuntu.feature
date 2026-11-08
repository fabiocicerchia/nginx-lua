@domain:container-runtime @area:config-templates @from:1-31-0/ubuntu
Feature: Configuration from environment templates
  Operators render nginx config from template files using container environment variables.

  Background:
    Given the nginx-lua Ubuntu 26.04 image

  @id:nginx.container-runtime.config-templates.997 @rule:runtime.templates.unreadable-output-dir-reported @inferred @source:nginx/1.31.0/ubuntu/26.04/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: An unwritable output directory is reported and nothing is rendered
    Given a template exists
    And the output directory is read-only
    When the operator starts the container
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And the container still continues to start nginx
