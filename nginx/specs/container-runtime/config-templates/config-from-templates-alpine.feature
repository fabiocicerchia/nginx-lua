@domain:container-runtime @area:config-templates @from:1-27-3/alpine
Feature: Rendering nginx configuration from templates
  Lets operators supply environment variables and template files so nginx configuration is generated at container start.

  Background:
    Given the container starts with the default command

  @id:nginx.container-runtime.config-templates.503 @rule:container-runtime.config-templates.settings-overridable @inferred @source:nginx/1.27.3/alpine/3.20.3/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template folder, suffix and output folder can be overridden
    Given a template /tpl/a.tmpl
    And NGINX_ENVSUBST_TEMPLATE_DIR=/tpl, NGINX_ENVSUBST_TEMPLATE_SUFFIX=.tmpl, NGINX_ENVSUBST_OUTPUT_DIR=/out
    When the operator starts the container
    Then /out/a is generated
