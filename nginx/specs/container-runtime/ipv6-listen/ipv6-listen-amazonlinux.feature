@domain:container-runtime @area:ipv6-listen @from:1-31-5/amazonlinux
Feature: IPv6 listening
  Operators expect the default site to listen on IPv6 when the host supports it.

  @id:nginx.container-runtime.ipv6-listen.028 @rule:runtime.ipv6.not-enabled-on-amazon-linux @inferred @source:nginx/1.31.5/amazonlinux/2023.12.20260817.0/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: The default site is not switched to IPv6 on Amazon Linux
    Given the container has IPv6 available
    And the default site configuration is writable and unmodified
    When the operator starts the container
    Then the log says "Unsupported distribution"
    And default.conf has no "listen  [::]:80;" line
