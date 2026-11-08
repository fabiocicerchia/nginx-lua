@domain:container-runtime @area:config-templates @from:1-19-10/fedora
Feature: Rendering configuration from templates
  Lets operators generate nginx configuration from environment variables at container start.

  Background:
    Given Given the Fedora 33 nginx-lua 1.19.10 image

  @id:nginx.container-runtime.config-templates.013 @rule:container.templates.unwritable-output-is-skipped @inferred @source:nginx/1.19.10/fedora/33/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Rendering is skipped with an error message when the output directory is not writable
    Given the template directory exists
    And the output directory is not writable
    When the operator starts the container with the default nginx command
    Then no file is rendered
    And the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And nginx still starts
