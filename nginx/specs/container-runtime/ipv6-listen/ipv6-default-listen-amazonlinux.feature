@domain:container-runtime @area:ipv6-listen @from:1-29-3/amazonlinux
Feature: IPv6 listening in the default site
  Operators expect the default site to listen on IPv6 where supported.

  @id:nginx.container-runtime.ipv6-listen.022 @rule:runtime.ipv6.not-enabled-on-amazonlinux @inferred @source:nginx/1.29.3/amazonlinux/2023.9.20251117.1/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: The default site is not given an IPv6 listener on Amazon Linux
    Given the container has IPv6 available
    And the default site configuration is unmodified
    When the operator starts the container
    Then the log shows "Unsupported distribution"
    And default.conf has no "listen  [::]:80;" line
