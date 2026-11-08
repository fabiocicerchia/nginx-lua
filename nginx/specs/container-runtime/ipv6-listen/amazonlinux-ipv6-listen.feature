@domain:container-runtime @area:ipv6-listen @from:1-19-7/amazonlinux
Feature: IPv6 listening on Amazon Linux
  Operators expect the default site to answer on IPv6 when the container has IPv6.

  Background:
    Given Given the nginx-lua 1.19.7 image on Amazon Linux

  @id:nginx.container-runtime.ipv6-listen.001 @rule:ipv6-listen.default-site.listens-on-ipv6-from-2-0-20210219 @inferred @source:nginx/1.19.7/amazonlinux/2.0.20210219.0/tpl/default.conf#server
  Scenario: The 2.0.20210219.0 image's default site listens on IPv6 port 80
    Given the image tagged 1.19.7-amazonlinux2.0.20210219.0
    And the container has IPv6 available
    When the operator starts the container with the default nginx command
    Then the default site listens on 0.0.0.0:80 and [::]:80
    And the log says IPv6 listen is already enabled
