@domain:container-runtime @area:ipv6-listen @from:1-31-4/alpine
Feature: IPv6 listening in the default site
  Aims to make the default site reachable over IPv6 when the container has IPv6.

  @id:nginx.container-runtime.ipv6-listen.027 @rule:container-runtime.ipv6-listen.enable-on-unmodified-default-conf @inferred @source:nginx/1.31.4/alpine/3.24.1/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: IPv6 listen is added only to an unmodified default site
    Given the container has IPv6 available
    And the default site config is writable and matches the packaged version
    When the operator starts the container with the default nginx command
    Then default.conf gains "listen  [::]:80;"
    And the log shows "Enabled listen on IPv6"
