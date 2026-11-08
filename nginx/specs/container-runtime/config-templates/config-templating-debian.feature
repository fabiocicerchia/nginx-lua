@domain:container-runtime @area:config-templates @from:1-31-7/debian
Feature: Configuration from templates
  Lets operators render nginx configuration from environment variables without building a custom image.

  Background:
    Given the nginx-lua Debian image is started with the default nginx command

  @id:nginx.container-runtime.config-templates.1126 @rule:container-runtime.config-templates.renders-templates-with-environment @inferred @source:nginx/1.31.7/debian/13.7/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template files are rendered into the nginx config directory with environment values
    Given a template default.conf.template referencing ${PORT} exists in /etc/nginx/templates
    And the environment sets PORT=8080
    When the operator starts the container
    Then /etc/nginx/conf.d/default.conf is created with 8080 in place of ${PORT}
    And the log shows "Running envsubst on /etc/nginx/templates/default.conf.template to /etc/nginx/conf.d/default.conf"
