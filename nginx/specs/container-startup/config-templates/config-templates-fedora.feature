@domain:container-startup @area:config-templates @from:1-19-4/fedora
Feature: Rendering nginx config from environment-variable templates
  Lets operators write nginx config templates that are filled in from container environment variables at start-up, so one image serves many environments.

  Background:
    Given Given a container from the nginx 1.19.4 Fedora 33 image

  @id:nginx.container-startup.config-templates.052 @rule:container-startup.templates.subdirectories-preserved @inferred @source:nginx/1.19.4/fedora/33/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template subdirectories are recreated under the config directory
    Given the template /etc/nginx/templates/sites/api.conf.template exists
    When the operator starts the container with the default command
    Then the directory /etc/nginx/conf.d/sites exists
    And the file /etc/nginx/conf.d/sites/api.conf holds the rendered template

  @id:nginx.container-startup.config-templates.053 @rule:container-startup.templates.configurable-locations @inferred @source:nginx/1.19.4/fedora/33/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Operators can change the template directory, template suffix and output directory
    Given the environment variable <variable> is "<value>"
    And a template exists at <template>
    When the operator starts the container with the default command
    Then the rendered file is written to <output>

    Examples:
      | variable                       | value             | template                               | output                     |
      | NGINX_ENVSUBST_TEMPLATE_DIR    | /config/templates | /config/templates/app.conf.template    | /etc/nginx/conf.d/app.conf |
      | NGINX_ENVSUBST_TEMPLATE_SUFFIX | .tpl              | /etc/nginx/templates/app.conf.tpl      | /etc/nginx/conf.d/app.conf |
      | NGINX_ENVSUBST_OUTPUT_DIR      | /etc/nginx/sites  | /etc/nginx/templates/app.conf.template | /etc/nginx/sites/app.conf  |

  @id:nginx.container-startup.config-templates.054 @rule:container-startup.templates.unwritable-output-skipped @inferred @source:nginx/1.19.4/fedora/33/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are skipped with an error when the output directory cannot be written
    Given the template directory /etc/nginx/templates contains templates
    And /etc/nginx/conf.d is mounted read-only
    When the operator starts the container with the default command
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no template is rendered
    And nginx still starts
