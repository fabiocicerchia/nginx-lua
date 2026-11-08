@domain:container-runtime @area:config-templates @from:1-19-6/amazonlinux
Feature: Configuration from environment-variable templates
  Operators render nginx configuration files from templates using container environment variables.

  Background:
    Given Given the nginx 1.19.6 Amazon Linux image

  @id:nginx.container-runtime.config-templates.067 @rule:container-runtime.config-templates.unwritable-output-is-reported-not-fatal @inferred @source:nginx/1.19.6/amazonlinux/2.0.20210126.0/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: An unwritable output directory is reported and nginx still starts
    Given the template directory exists
    And the output directory is not writable
    When the operator starts the container with the default nginx command
    Then the log says "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no template is rendered
    And nginx is still launched
