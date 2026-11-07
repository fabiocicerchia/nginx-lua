@domain:container-startup @area:config-templates @from:1-19-4/amazonlinux
Feature: Rendering configuration templates from environment variables
  Operators keep nginx config as templates and fill them with environment variables when the container starts.

  Background:
    Given the operator runs the nginx-lua Amazon Linux 2 image for nginx 1.19.4 with the command "nginx -g 'daemon off;'"

  @id:nginx.container-startup.config-templates.044 @rule:container.templates.rendered-into-output-dir @inferred @source:nginx/1.19.4/amazonlinux/2.0.20200722.0/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario Outline: Each template is rendered into the config directory without its suffix
    Given the directory /etc/nginx/conf.d exists and is writable
    And the template "/etc/nginx/templates/<template>" exists
    And the environment variable SERVER_NAME is "www.example.com"
    When the operator starts the container
    Then the file "/etc/nginx/conf.d/<output>" exists
    And every ${SERVER_NAME} in it reads "www.example.com"
    And the container log shows "Running envsubst on /etc/nginx/templates/<template> to /etc/nginx/conf.d/<output>"

    Examples:
      | template                 | output          |
      | default.conf.template    | default.conf    |
      | sites/shop.conf.template | sites/shop.conf |
