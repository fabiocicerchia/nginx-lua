@domain:web-server @area:debug-binary @from:1-19-3/amazonlinux
Feature: Shipping an nginx-debug binary
  Lets operators switch to a debug-enabled nginx to troubleshoot without rebuilding the image.

  @id:nginx.web-server.debug-binary.001 @rule:web-server.debug-binary.available-per-variant @inferred @source:nginx/1.19.3/amazonlinux/2.0.20200722.0/tpl/Makefile#core @questionable
  Scenario Outline: An nginx-debug binary is shipped in the Amazon Linux 2.0.20200722.0 image but not in 2.0.20200602.0
    Given a container from the nginx 1.19.3 Amazon Linux "<os_tag>" image
    When the operator starts it with the command "nginx-debug -g 'daemon off;'"
    Then <outcome>

    Examples:
      | os_tag         | outcome                                                                          |
      | 2.0.20200722.0 | the startup hooks run and nginx starts with debug logging available              |
      | 2.0.20200602.0 | the startup hooks run, then the container fails because nginx-debug is not found |
