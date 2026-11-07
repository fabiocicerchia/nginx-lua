@domain:container-startup @area:config-templates @from:1-19-3/debian
Feature: Rendering nginx config from environment-variable templates
  Operators can keep nginx config as templates and have environment values filled in at container start, so one image works across environments.

  Background:
    Given an nginx-lua 1.19.3 container built from the debian 10.6 image
    And the bundled template hook is in /docker-entrypoint.d

  @id:nginx.container-startup.config-templates.027 @rule:container.templates.defined-variables-substituted @inferred @source:nginx/1.19.3/debian/10.6/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are rendered with defined environment variables, and other dollar references are left alone
    Given /etc/nginx/templates/site.conf.template contains "server_name ${SERVER_NAME}; return 200 $host;"
    And the environment variable SERVER_NAME is set to "www.example.com"
    And the environment variable host is not set
    And /etc/nginx/conf.d exists and is writable
    When the operator starts the container with the default command
    Then /etc/nginx/conf.d/site.conf contains "server_name www.example.com; return 200 $host;"
    And the log shows "Running envsubst on /etc/nginx/templates/site.conf.template to /etc/nginx/conf.d/site.conf"

  @id:nginx.container-startup.config-templates.030 @rule:container.templates.no-template-dir-no-op @inferred @source:nginx/1.19.3/debian/10.6/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Without a templates directory nothing is rendered
    Given the directory /etc/nginx/templates does not exist
    When the operator starts the container with the default command
    Then no files are written to /etc/nginx/conf.d
    And no template error is logged
    And nginx starts
