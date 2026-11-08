@domain:auto-configuration @area:ipv6-listen @from:src/10-listen-on-ipv6-by-default
Feature: Listening on IPv6 by default
  Lets operators running the container on an IPv6-capable host get the default web server answering on IPv6 without editing configuration, while never overwriting customised configuration.

  Background:
    Given Given the container starts with the default startup scripts

  @id:src.auto-configuration.ipv6-listen.001 @rule:auto-configuration.ipv6-listen.enabled-on-pristine-default-config @inferred @source:src/10-listen-on-ipv6-by-default.sh#sed
  Scenario: The default site also listens on IPv6 when the host supports it and the config is unmodified
    Given the host has IPv6 available
    And the default site configuration is the unmodified packaged version on a supported distribution
    And the default site configuration is writable
    When the container starts
    Then the default site configuration gains a line "listen  [::]:80;" after "listen       80;"
    And the startup log shows "info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf"

  @id:src.auto-configuration.ipv6-listen.002 @rule:auto-configuration.ipv6-listen.customised-config-untouched @inferred @source:src/10-listen-on-ipv6-by-default.sh#case
  Scenario: A customised default site configuration is left unchanged
    Given the host has IPv6 available
    And the default site configuration differs from the packaged version
    When the container starts
    Then the default site configuration is not modified
    And the startup log shows "info: /etc/nginx/conf.d/default.conf differs from the packaged version"

  @id:src.auto-configuration.ipv6-listen.003 @rule:container-startup.startup-logging.quiet-logs-suppress-ipv6-messages @inferred @source:src/10-listen-on-ipv6-by-default.sh#entrypoint_log @questionable
  Scenario: Quiet mode hides the IPv6 setup messages
    Given the operator has requested quiet startup logs
    And the host has no IPv6 available
    When the container starts
    Then no "ipv6 not available" message is printed
    And the startup continues without error
