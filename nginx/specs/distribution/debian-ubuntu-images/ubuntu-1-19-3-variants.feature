@domain:distribution @area:debian-ubuntu-images @from:1-19-3/ubuntu
Feature: Ubuntu variants of nginx 1.19.3
  Which Ubuntu releases nginx 1.19.3 is published on, so users can pick a tag that exists.

  @id:nginx.distribution.debian-ubuntu-images.029 @rule:distribution.ubuntu.nginx-1-19-3-releases @inferred @source:nginx/1.19.3/ubuntu/20.10/Dockerfile#COPY @questionable
  Scenario Outline: nginx 1.19.3 can be built on Ubuntu 20.04 but not on Ubuntu 20.10
    Given the maintainer builds the nginx 1.19.3 image for Ubuntu <release>
    When the build runs
    Then the build <outcome>

    Examples:
      | release | outcome                                                      |
      | 20.04   | produces an image that passes the nginx config check         |
      | 20.10   | fails because the startup hook scripts it copies are missing |
