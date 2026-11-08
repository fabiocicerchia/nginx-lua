@domain:container-runtime @area:ipv6-listen @from:1-29-3/fedora
Feature: IPv6 listening in the default site
  Lets operators expect IPv6 connectivity on the default site.

  Background:
    Given the Fedora 42 image for nginx 1.29.3

  @id:nginx.container-runtime.ipv6-listen.023 @rule:container-runtime.ipv6-listen.not-enabled-on-fedora @inferred @source:nginx/1.29.3/fedora/42/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: The default site is not given an IPv6 listener on Fedora
    Given the container has IPv6 available
    And the default site is unmodified and writable
    When the operator starts the container with the default nginx command
    Then the log shows "info: Unsupported distribution"
    And default.conf has no "listen  [::]:80;" line
