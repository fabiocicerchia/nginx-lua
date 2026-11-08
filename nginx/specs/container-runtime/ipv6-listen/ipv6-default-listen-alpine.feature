@domain:container-runtime @area:ipv6-listen @from:1-31-4/alpine
Feature: IPv6 listening in the default site
  Aims to make the default site reachable over IPv6 when the container has IPv6.

  @id:nginx.container-runtime.ipv6-listen.027 @rule:container-runtime.ipv6-listen.enable-on-unmodified-default-conf @inferred @source:nginx/1.31.4/alpine/3.24.1/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: IPv6 listen is not added because nginx is not an Alpine package
    Given the container has IPv6 available
    And the default site config is writable and unmodified
    When the operator starts the container with the default nginx command
    Then the default site still listens only on IPv4 port 80
    And the log shows "differs from the packaged version"
