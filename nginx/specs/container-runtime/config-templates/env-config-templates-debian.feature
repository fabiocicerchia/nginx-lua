@domain:container-runtime @area:config-templates @from:1-21-3/debian
Feature: Rendering configuration from templates
  Operators inject environment variables into nginx configuration by mounting templates.

  @id:nginx.container-runtime.config-templates.155 @rule:runtime.templates.directory-and-suffix-configurable @inferred @source:nginx/1.21.3/debian/11.1/tpl/20-envsubst-on-templates.sh#auto_envsubst
  Scenario: Template directory, suffix and output directory can be overridden
    Given NGINX_ENVSUBST_TEMPLATE_DIR, NGINX_ENVSUBST_TEMPLATE_SUFFIX and NGINX_ENVSUBST_OUTPUT_DIR are set
    When the operator starts the container
    Then files in the chosen directory with the chosen suffix are rendered to the chosen output directory without the suffix
    And subdirectories of the template directory are recreated under the output directory
