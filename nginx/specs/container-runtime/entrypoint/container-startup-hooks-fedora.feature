@domain:container-runtime @area:entrypoint @from:1-27-2/fedora
Feature: Container startup hooks
  Operators running the image get startup scripts in /docker-entrypoint.d executed in order before nginx starts.

  Background:
    Given Given the Fedora nginx-lua image 1.27.2 (Fedora 40 or 41)

  @id:nginx.container-runtime.entrypoint.123 @rule:container-runtime.entrypoint.hooks-only-for-nginx-commands @inferred @source:nginx/1.27.2/fedora/40/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Startup scripts are skipped when the container runs another command
    Given the startup directory holds the default scripts
    When the operator starts the container with the command "sh"
    Then no startup script is launched
    And the command runs directly
