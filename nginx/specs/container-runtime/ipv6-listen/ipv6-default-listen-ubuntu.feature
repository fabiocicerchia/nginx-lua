@domain:container-runtime @area:ipv6-listen @from:1-25-1/ubuntu
Feature: IPv6 listening in the default site
  Lets operators on IPv6-capable hosts reach the default site over IPv6 without editing configuration.

  Background:
    Given Given the nginx-lua 1.25.1 Ubuntu 22.04 image

  @id:nginx.container-runtime.ipv6-listen.003 @rule:runtime.ipv6.default-site-listens-on-ipv6 @inferred @source:nginx/1.25.1/ubuntu/22.04/tpl/10-listen-on-ipv6-by-default.sh#DEFAULT_CONF_FILE @questionable
  Scenario: The default site is switched to also listen on IPv6
    Given the container has IPv6 available
    And the default site configuration is unmodified from the packaged version
    When the operator starts the container with the command nginx
    Then the default site listens on [::]:80 as well as port 80
    And the logs show "Enabled listen on IPv6"

  @id:nginx.container-runtime.ipv6-listen.004 @rule:runtime.ipv6.leaves-config-alone-when-unsuitable @inferred @source:nginx/1.25.1/ubuntu/22.04/tpl/10-listen-on-ipv6-by-default.sh#DEFAULT_CONF_FILE
  Scenario Outline: The default site is left unchanged when IPv6 cannot or should not be enabled
    Given <condition>
    When the operator starts the container with the command nginx
    Then the default site configuration is not changed
    And the logs show an info message and startup continues

    Examples:
      | condition                                           |
      | IPv6 is not available                               |
      | the default site file is missing                    |
      | the default site file is on a read-only file system |
      | IPv6 listen is already enabled                      |
      | the default site was customised                     |
