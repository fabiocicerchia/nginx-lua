@domain:container-startup @area:config-templates @from:1-19-4/ubuntu
Feature: Rendering configuration from environment-variable templates
  Lets operators parametrise nginx configuration with environment variables at container start instead of baking values into the image.

  Background:
    Given the operator runs the nginx 1.19.4 Ubuntu 20.04 image with the default command

  @id:nginx.container-startup.config-templates.055 @rule:container.templates.render-defined-env-vars @inferred @source:nginx/1.19.4/ubuntu/20.04/tpl/20-envsubst-on-templates.sh#auto_envsubst @questionable
  Scenario: Templates are rendered with only the environment variables that are defined
    Given the environment variable BACKEND_HOST is "api.example.com"
    And /etc/nginx/templates/site/app.conf.template contains "proxy_pass http://${BACKEND_HOST}; set $x $host;"
    And /etc/nginx/conf.d is writable
    When the operator starts the container
    Then /etc/nginx/conf.d/site/app.conf exists
    And it contains "proxy_pass http://api.example.com; set $x $host;"
    And the log shows "Running envsubst on /etc/nginx/templates/site/app.conf.template to /etc/nginx/conf.d/site/app.conf"
