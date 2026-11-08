@domain:container-runtime @area:entrypoint @from:1-30-4/ubuntu
Feature: Container startup hooks
  Lets operators customise the container at start-up with hook scripts before nginx launches, while other commands run untouched.

  Background:
    Given the nginx-lua Ubuntu 26.04 image

  @id:nginx.container-runtime.entrypoint.252 @rule:container-runtime.entrypoint.non-nginx-commands-bypass-hooks @inferred @source:nginx/1.30.4/ubuntu/26.04/tpl/docker-entrypoint.sh#docker-entrypoint
  Scenario: Running another command skips all startup configuration
    Given /docker-entrypoint.d contains executable startup scripts
    When the operator starts the container with the command "sh"
    Then no startup script runs
    And the shell is started directly
