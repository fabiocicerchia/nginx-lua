@domain:container-runtime @area:config-templates @from:1-29-6/almalinux
Feature: Rendering configuration from templates
  Serves operators who configure nginx through environment variables instead of editing files.

  Background:
    Given Given the almalinux 1.29.6 image is started with the default nginx command

  @id:nginx.container-runtime.config-templates.789 @rule:container.templates.nginx-variables-preserved @inferred @source:nginx/1.29.6/almalinux/10.1-20260129/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Only defined environment variables are substituted; nginx variables stay intact
    Given a template contains "proxy_set_header Host $host; # ${BACKEND}"
    And BACKEND is app.internal and no environment variable named host exists
    When the operator starts the container
    Then the rendered file contains "proxy_set_header Host $host; # app.internal"
