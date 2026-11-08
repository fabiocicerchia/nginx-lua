@domain:container-runtime @area:ipv6-listen @from:1-30-1/ubuntu
Feature: IPv6 listening in the default site
  Intended to let the default site accept IPv6 connections automatically.

  Background:
    Given the nginx-lua image for Ubuntu 26.04 is started with the default nginx command

  @id:nginx.container-runtime.ipv6-listen.025 @rule:container-runtime.ipv6-listen.not-enabled-on-ubuntu @inferred @source:nginx/1.30.1/ubuntu/26.04/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: The default site is not given an IPv6 listener on an Ubuntu image
    Given the container has IPv6 available
    And /etc/nginx/conf.d/default.conf exists and is writable
    When the operator starts the container
    Then the log shows "info: Unsupported distribution"
    And default.conf has no "listen  [::]:80;" line
