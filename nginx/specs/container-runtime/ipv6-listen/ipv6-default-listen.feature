@domain:container-runtime @area:ipv6-listen @from:1-25-1/almalinux
Feature: IPv6 listening in the default site
  Tells operators whether the default site accepts IPv6 connections out of the box.

  Background:
    Given the AlmaLinux 9.2 nginx-lua image is started

  @id:nginx.container-runtime.ipv6-listen.002 @rule:runtime.ipv6.almalinux-default-site-stays-ipv4-only @inferred @source:nginx/1.25.1/almalinux/9.2-20230718/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: The default site is not switched to IPv6 on AlmaLinux
    Given the container has IPv6 available
    And the default site configuration is unmodified
    When the operator starts the container with the default nginx command
    Then the log shows "info: Unsupported distribution"
    And the default site still listens only on IPv4 port 80
