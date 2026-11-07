@domain:container-startup @area:config-templates @from:1-19-4/alpine
Feature: Rendering configuration templates from environment variables
  Lets operators write nginx config templates with ${VAR} references that are filled from the container environment at start-up.

  Background:
    Given the nginx-lua 1.19.4 Alpine 3.12.1 image
    And the container is started with the default command

  @id:nginx.container-startup.config-templates.039 @rule:container.templates.render-into-output-dir @inferred @source:nginx/1.19.4/alpine/3.12.1/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Each template is rendered into the output folder under its name without the suffix
    Given NGINX_PORT is set to "8080"
    And <template> contains "listen ${NGINX_PORT};"
    When the operator starts the container
    Then <output> exists and contains "listen 8080;"
    And the log shows "Running envsubst on <template> to <output>"

    Examples:
      | template                                      | output                            |
      | /etc/nginx/templates/default.conf.template    | /etc/nginx/conf.d/default.conf    |
      | /etc/nginx/templates/sites/shop.conf.template | /etc/nginx/conf.d/sites/shop.conf |
