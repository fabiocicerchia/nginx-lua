@domain:container-runtime @area:ipv6-listen @from:1-29-3/almalinux
Feature: IPv6 listening in the default site
  Operators expect the default site to also listen on IPv6 when the host supports it.

  Background:
    Given the AlmaLinux nginx-lua image is started

  @id:nginx.container-runtime.ipv6-listen.021 @rule:container-runtime.ipv6-listen.not-enabled-on-almalinux @inferred @source:nginx/1.29.3/almalinux/9.7-20251119/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: The default site is not switched to IPv6 on AlmaLinux
    Given the container has IPv6 available
    And the default site configuration is unmodified
    When the operator starts the container
    Then the log shows "info: Unsupported distribution"
    And default.conf still has no "listen  [::]:80;" line
