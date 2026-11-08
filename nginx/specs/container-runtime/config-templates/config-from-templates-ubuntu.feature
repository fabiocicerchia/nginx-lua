@domain:container-runtime @area:config-templates @from:1-28-3/ubuntu
Feature: Rendering configuration from templates
  Lets operators configure nginx through environment variables by turning template files into real config at start.

  Background:
    Given The 20-envsubst-on-templates.sh hook runs at start
    And Default template folder /etc/nginx/templates, suffix .template, output /etc/nginx/conf.d

  @id:nginx.container-runtime.config-templates.653 @rule:runtime.templates.stream-templates-enabled-in-main-config @inferred @source:nginx/1.28.3/ubuntu/24.04/tpl/20-envsubst-on-templates.sh#add_stream_block @questionable
  Scenario: Stream templates are rendered and wired into the main configuration
    Given a template tcp.conf.stream-template in the template folder
    And the main nginx.conf has no stream block
    When the operator starts the container
    Then stream-conf.d/tcp.conf is rendered
    And nginx.conf gets an appended stream block including stream-conf.d/*.conf
