@domain:container-runtime @area:config-templates @from:1-23-2/debian
Feature: Rendering configuration from templates
  Operators supply nginx configuration with environment variables substituted at startup.

  Background:
    Given the nginx-lua Debian 11.5 image for nginx 1.23.2

  @id:nginx.container-runtime.config-templates.264 @rule:container.templates.unwritable-output-is-reported @inferred @source:nginx/1.23.2/debian/11.5/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: An unwritable output directory is reported and nginx still starts
    Given a templates directory exists
    And the output directory is not writable
    When the operator starts the container with the command nginx
    Then the log says "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no template is rendered
    And nginx still starts
