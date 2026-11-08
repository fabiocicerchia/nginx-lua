@domain:container-runtime @area:ipv6-listen @from:1-29-1/debian
Feature: IPv6 listening in the default site
  Operators on IPv6-capable hosts get the default site listening on IPv6 without editing configuration.

  Background:
    Given Given the nginx-lua Debian 13 image is started with the default nginx command

  @id:nginx.container-runtime.ipv6-listen.018 @rule:container-runtime.ipv6-listen.enabled-when-available-and-unmodified @inferred @source:nginx/1.29.1/debian/13.1/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: The default site also listens on IPv6 when the host supports it
    Given the container network supports IPv6
    And the default site configuration matches the packaged one
    When the operator starts the container
    Then the default site gains the line "listen  [::]:80;" after "listen       80;"
    And the log shows "Enabled listen on IPv6"
