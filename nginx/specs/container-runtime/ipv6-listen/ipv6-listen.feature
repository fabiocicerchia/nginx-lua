@domain:container-runtime @area:ipv6-listen @from:1-27-1/alpine
Feature: Enabling IPv6 on the default site
  Gives operators IPv6 reachability on the default server without manual edits.

  Background:
    Given Given the Alpine nginx-lua 1.27.1 image

  @id:nginx.container-runtime.ipv6-listen.010 @rule:container-runtime.ipv6-listen.enabled-when-available @inferred @source:nginx/1.27.1/alpine/3.20.3/tpl/10-listen-on-ipv6-by-default.sh @questionable
  Scenario: IPv6 listening is added to the unmodified default site
    Given the container has IPv6 available
    And the default site is the packaged unmodified version
    When the operator starts the container
    Then the default site also listens on [::]:80
    And "Enabled listen on IPv6" is printed

  @id:nginx.container-runtime.ipv6-listen.011 @rule:container-runtime.ipv6-listen.left-alone-when-not-applicable @inferred @source:nginx/1.27.1/alpine/3.20.3/tpl/10-listen-on-ipv6-by-default.sh
  Scenario Outline: The default site is left unchanged when IPv6 is unavailable, already enabled or customised
    Given the default site must not change
    When the operator starts the container
    Then the file is not modified
    And an info message gives the reason

    Examples:
      | condition                     | message                           |
      | no IPv6 on host               | ipv6 not available                |
      | already has [::]:80           | IPv6 listen already enabled       |
      | read-only filesystem          | can not modify                    |
      | differs from packaged version | differs from the packaged version |
