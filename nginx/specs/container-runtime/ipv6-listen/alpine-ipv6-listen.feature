@domain:container-runtime @area:ipv6-listen @from:1-29-2/alpine
Feature: Automatic IPv6 listening
  Operators expect the default server to also listen on IPv6 when the container has IPv6.

  Background:
    Given Given the nginx-lua Alpine image with the stock default.conf and IPv6 available in the container

  @id:nginx.container-runtime.ipv6-listen.020 @rule:ipv6.default-conf.listen-enabled-on-alpine @inferred @source:nginx/1.29.2/alpine/3.22.2/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: The default site listens on IPv6 at startup
    Given the container has IPv6 and an unmodified default.conf
    When the operator starts the container
    Then default.conf gains "listen  [::]:80;"
    And the log shows "Enabled listen on IPv6"
