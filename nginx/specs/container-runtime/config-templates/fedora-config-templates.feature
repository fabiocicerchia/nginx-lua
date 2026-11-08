@domain:container-runtime @area:config-templates @from:1-19-3/fedora
Feature: Rendering configuration from templates
  Lets operators configure nginx through environment variables by rendering template files at container start.

  Background:
    Given Given the Fedora nginx-lua image is used

  @id:nginx.container-runtime.config-templates.027 @rule:container-runtime.config-templates.variable-substitution @inferred @source:nginx/1.19.3/fedora/33/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template files are rendered with environment variables
    Given the file "/etc/nginx/templates/site.conf.template" contains "listen ${PORT};"
    And the variable PORT is "8080"
    When the operator starts the container with the default nginx command
    Then "/etc/nginx/conf.d/site.conf" contains "listen 8080;"
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-runtime.config-templates.028 @rule:container-runtime.config-templates.unwritable-output-refused @inferred @source:nginx/1.19.3/fedora/33/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are not rendered when the output directory is read-only
    Given templates exist
    And the output directory is not writable
    When the operator starts the container with the default nginx command
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And nginx still starts

  @id:nginx.container-runtime.config-templates.029 @rule:platform-support.fedora.startup-scripts-shipped @inferred @source:nginx/1.19.3/fedora/34/Dockerfile#COPY @questionable
  Scenario: The Fedora 34 image ships the startup scripts it copies
    Given the Fedora 34 image build context
    When the operator builds the Fedora 34 image
    Then the image contains the IPv6 and template startup scripts in the startup hook directory
