@domain:container-startup @area:config-templates @from:1-19-10/debian
Feature: Rendering configuration from environment-variable templates
  Lets operators set up nginx per environment by writing templates that are filled with environment variables when the container starts.

  Background:
    Given the container is started with the command "nginx -g 'daemon off;'"

  @id:nginx.container-startup.config-templates.009 @rule:container.templates.rendered-into-conf-dir @inferred @source:nginx/1.19.10/debian/10.9/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Each template is rendered into the config directory with its suffix removed
    Given the template /etc/nginx/templates/<template> exists
    And the environment variable BACKEND_HOST is "api.example.com"
    When the container starts
    Then the file /etc/nginx/conf.d/<output> exists
    And every "${BACKEND_HOST}" in it reads "api.example.com"
    And the log shows "Running envsubst on /etc/nginx/templates/<template> to /etc/nginx/conf.d/<output>"

    Examples:
      | template                 | output          |
      | site.conf.template       | site.conf       |
      | sites/shop.conf.template | sites/shop.conf |

  @id:nginx.container-startup.config-templates.010 @rule:container.templates.only-defined-variables-substituted @inferred @source:nginx/1.19.10/debian/10.9/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Only variables defined in the environment are replaced, so nginx variables survive
    Given the environment variable BACKEND_HOST is "api.example.com"
    And no environment variable named "host" or "UNSET_VAR" exists
    And the template /etc/nginx/templates/site.conf.template contains "<line>"
    When the container starts
    Then /etc/nginx/conf.d/site.conf contains "<rendered>"

    Examples:
      | line                               | rendered                           |
      | proxy_pass http://${BACKEND_HOST}; | proxy_pass http://api.example.com; |
      | proxy_set_header Host $host;       | proxy_set_header Host $host;       |
      | set $x ${UNSET_VAR};               | set $x ${UNSET_VAR};               |

  @id:nginx.container-startup.config-templates.011 @rule:container.templates.locations-configurable @inferred @source:nginx/1.19.10/debian/10.9/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: The operator can change the template directory, suffix and output directory
    Given NGINX_ENVSUBST_TEMPLATE_DIR is "/config/tpl"
    And NGINX_ENVSUBST_TEMPLATE_SUFFIX is ".tmpl"
    And NGINX_ENVSUBST_OUTPUT_DIR is "/etc/nginx/sites"
    And the template /config/tpl/app.conf.tmpl exists
    When the container starts
    Then the file /etc/nginx/sites/app.conf holds the rendered template
    And files in /config/tpl without the ".tmpl" suffix are not rendered
