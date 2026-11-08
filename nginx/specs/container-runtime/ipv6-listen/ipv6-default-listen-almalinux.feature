@domain:container-runtime @area:ipv6-listen @from:1-25-5/almalinux
Feature: Enabling IPv6 on the default site
  Intended to let the default site accept IPv6 connections automatically.

  Background:
    Given Given the AlmaLinux 9.4 nginx-lua image is started

  @id:nginx.container-runtime.ipv6-listen.008 @rule:runtime.ipv6.not-enabled-on-almalinux @inferred @source:nginx/1.25.5/almalinux/9.4-20240506/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: IPv6 listening is not enabled on AlmaLinux images
    Given the container has IPv6 available
    And the default site is unmodified
    When the operator starts the container
    Then the log shows "info: Unsupported distribution"
    And the default site still listens only on IPv4 port 80
