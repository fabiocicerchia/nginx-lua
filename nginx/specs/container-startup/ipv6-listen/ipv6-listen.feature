@domain:container-startup @area:ipv6-listen @from:1-19-10/ubuntu
Feature: Listening on IPv6 by default
  Makes the default site reachable over IPv6 without extra configuration, and leaves the config alone when it cannot or should not be changed.

  Background:
    Given the operator starts the container with the default command

  @id:nginx.container-startup.ipv6-listen.001 @rule:container.ipv6-listen.shipped-default-site-already-dual-stack @inferred @source:nginx/1.19.10/ubuntu/20.04/tpl/default.conf#server @questionable
  Scenario: The shipped default site already listens on IPv6 port 80
    Given the default site config is the one shipped in the image
    And the host supports IPv6
    When the container starts
    Then the default site listens on port 80 over IPv4 and IPv6
    And the container log shows "10-listen-on-ipv6-by-default.sh: error: IPv6 listen already enabled"
    And the default site config is not changed

  @id:nginx.container-startup.ipv6-listen.002 @rule:container.ipv6-listen.shipped-ipv6-listener-on-ipv4-only-host @inferred @source:nginx/1.19.10/ubuntu/20.04/tpl/default.conf#server @questionable
  Scenario: On a host without IPv6 the shipped default site still asks for an IPv6 listener
    Given the host has no IPv6 support
    And the default site config is the one shipped in the image
    When the container starts
    Then the container log shows "10-listen-on-ipv6-by-default.sh: error: ipv6 not available"
    And the default site still contains "listen  [::]:80;"
    And nginx reports that it cannot open the [::]:80 listener and does not start
