@domain:distribution @area:amazon-linux-images @from:1-19-3/amazonlinux
Feature: nginx 1.19.3 images on Amazon Linux 2
  Tells customers which Amazon Linux 2 tags they can pull nginx 1.19.3 with Lua for.

  @id:nginx.distribution.amazon-linux-images.023 @rule:distribution.amazon-linux.1-19-3-os-tags @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200602.0/Dockerfile#COPY @questionable
  Scenario Outline: nginx 1.19.3 with Lua is built for Amazon Linux 2 point releases
    Given the image definition for Amazon Linux "<os_tag>"
    When the release pipeline builds the image
    Then <outcome>

    Examples:
      | os_tag         | outcome                                                                                                                     |
      | 2.0.20200722.0 | an image tagged "1.19.3-amazonlinux2.0.20200722.0" is produced, and it passes the envsubst -V, nginx -V and nginx -t checks |
      | 2.0.20200602.0 | the build stops because the startup hook scripts it copies are missing from its template folder                             |
