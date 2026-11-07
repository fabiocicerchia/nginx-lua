@domain:container-startup @area:config-templates @from:1-19-10/alpine
Feature: Rendering nginx config from environment-variable templates
  Lets operators keep one config template and set hostnames, ports and similar values per environment through container environment variables.

  Background:
    Given the container image nginx-lua 1.19.10 on Alpine 3.13
    And the container is started with the command "nginx"

  @id:nginx.container-startup.config-templates.001 @rule:container.templates.render-into-conf-d @inferred @source:nginx/1.19.10/alpine/3.13.5/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Each template is rendered into the config directory with the suffix removed, keeping subfolders
    Given the file "<template>" exists under /etc/nginx/templates
    And the environment variable SERVER_NAME is "www.example.com"
    And the template contains "server_name ${SERVER_NAME};"
    When the operator starts the container
    Then the file "<output>" exists
    And it contains "server_name www.example.com;"
    And the log shows "Running envsubst on" the template, naming the output path

    Examples:
      | template                                       | output                             |
      | /etc/nginx/templates/site.conf.template        | /etc/nginx/conf.d/site.conf        |
      | /etc/nginx/templates/vhosts/shop.conf.template | /etc/nginx/conf.d/vhosts/shop.conf |

  @id:nginx.container-startup.config-templates.002 @rule:container.templates.only-defined-variables-replaced @inferred @source:nginx/1.19.10/alpine/3.13.5/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Only variables set in the container environment are replaced; nginx variables stay intact
    Given the environment variable BACKEND_HOST is "api.example.com"
    And no environment variable named host is set
    And the template contains "proxy_pass http://${BACKEND_HOST}; proxy_set_header Host $host;"
    When the operator starts the container
    Then the rendered config contains "proxy_pass http://api.example.com;"
    And the rendered config still contains "proxy_set_header Host $host;"

  @id:nginx.container-startup.config-templates.003 @rule:container.templates.custom-locations @inferred @source:nginx/1.19.10/alpine/3.13.5/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Operators can change the template folder, suffix and output folder
    Given the environment variable <variable> is "<value>"
    And a template exists that matches that setting
    When the operator starts the container
    Then the template is rendered according to "<value>" instead of the default "<default>"

    Examples:
      | variable                       | value             | default              |
      | NGINX_ENVSUBST_TEMPLATE_DIR    | /config/templates | /etc/nginx/templates |
      | NGINX_ENVSUBST_TEMPLATE_SUFFIX | .tpl              | .template            |
      | NGINX_ENVSUBST_OUTPUT_DIR      | /etc/nginx/sites  | /etc/nginx/conf.d    |

  @id:nginx.container-startup.config-templates.004 @rule:container.templates.unwritable-output-skipped @inferred @source:nginx/1.19.10/alpine/3.13.5/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: Templates are not rendered when the output folder is read-only, and start-up continues
    Given the folder /etc/nginx/templates contains "site.conf.template"
    And /etc/nginx/conf.d is mounted read-only
    When the operator starts the container
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no template is rendered
    And nginx still starts with the existing config
