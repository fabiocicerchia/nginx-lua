@domain:container-runtime @area:ipv6-listen @from:1-27-2/amazonlinux
Feature: Enabling IPv6 listening in the default site
  Operators expect the default site to listen on IPv6 when available; on Amazon Linux it is never enabled.

  Background:
    Given the nginx-lua image based on Amazon Linux 2023

  @id:nginx.container-runtime.ipv6-listen.012 @rule:container-runtime.ipv6-listen.unsupported-on-amazonlinux @inferred @source:nginx/1.27.2/amazonlinux/2023.6.20241111.0/tpl/10-listen-on-ipv6-by-default.sh#case @questionable
  Scenario: The default site does not gain an IPv6 listener on Amazon Linux
    Given the container has IPv6 available
    And the default configuration is unmodified and writable
    When the operator starts the container with the default nginx command
    Then the log shows "Unsupported distribution"
    And /etc/nginx/conf.d/default.conf is unchanged and has no "listen  [::]:80;" line
