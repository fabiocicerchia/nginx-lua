@domain:container-runtime @area:config-templates @from:1-31-8/amazonlinux
Feature: Configuration from environment-variable templates
  Lets operators generate nginx configuration from templates using container environment variables.

  Background:
    Given the Amazon Linux nginx-lua image 1.31.8

  @id:nginx.container-runtime.config-templates.1146 @rule:container-runtime.config-templates.undefined-variables-untouched @inferred @source:nginx/1.31.8/amazonlinux/2023.12.20261021.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Variables not defined in the environment are left as written
    Given a template contains "$host" and "${PORT}"
    And PORT is defined and no variable named host exists
    When the operator starts the container
    Then the rendered file keeps "$host" unchanged
    And the rendered file has PORT replaced by its value
