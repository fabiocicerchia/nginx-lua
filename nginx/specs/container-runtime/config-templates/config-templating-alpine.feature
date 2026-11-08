@domain:container-runtime @area:config-templates @from:1-31-4/alpine
Feature: Rendering configuration from templates
  Lets operators generate nginx configuration from environment variables at container start.

  @id:nginx.container-runtime.config-templates.1054 @rule:container-runtime.config-templates.output-dir-must-be-writable @inferred @source:nginx/1.31.4/alpine/3.24.1/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Templates are not rendered when the output directory is read-only
    Given templates exist in /etc/nginx/templates
    And the output directory is not writable
    When the operator starts the container with the default nginx command
    Then the log shows "ERROR: /etc/nginx/templates exists, but /etc/nginx/conf.d is not writable"
    And no file is rendered
    And nginx still starts

  @id:nginx.container-runtime.config-templates.1055 @rule:container-runtime.config-templates.stream-templates-get-stream-block @inferred @source:nginx/1.31.4/alpine/3.24.1/tpl/20-envsubst-on-templates.sh#add_stream_block
  Scenario: Stream templates are rendered and wired into nginx.conf
    Given the file /etc/nginx/templates/tcp.conf.stream-template exists
    And nginx.conf has no stream block
    When the operator starts the container with the default nginx command
    Then /etc/nginx/stream-conf.d/tcp.conf is rendered
    And nginx.conf gains a stream block that includes /etc/nginx/stream-conf.d/*.conf
