@domain:distribution @area:amazon-linux-images @from:1-19-1/amazonlinux
Feature: Running the nginx 1.19.1 Amazon Linux 2 container
  Operators who deploy nginx-lua on Amazon Linux 2 rely on a fixed runtime contract (default site, health, logs, shutdown, user, labels) to run and monitor the container.

  Background:
    Given Given the operator runs a container from the nginx-lua 1.19.1 Amazon Linux 2 image

  @id:nginx.distribution.amazon-linux-images.016 @rule:images.metadata.labels-identify-nginx-and-os-release @inferred @source:nginx/1.19.1/amazonlinux/2.0.20200722.0/Dockerfile#LABEL
  Scenario Outline: Image labels identify the nginx version and the Amazon Linux release
    Given the image was built on Amazon Linux base release <os_release>
    When the operator inspects the image labels
    Then label "org.label-schema.version" is "1.19.1-amazonlinux<os_release>"
    And label "versions.os" is "<os_release>"
    And label "versions.nginx" is "1.19.1" and label "versions.lua-nginx-module" is "0.10.15"
    And label "org.label-schema.docker.cmd" is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.19.1-amazonlinux<os_release>"

    Examples:
      | os_release     |
      | 2.0.20200406.0 |
      | 2.0.20200602.0 |
      | 2.0.20200722.0 |

  @id:nginx.distribution.amazon-linux-images.017 @rule:container.default-config.serves-default-site @inferred @source:nginx/1.19.1/amazonlinux/2.0.20200722.0/Dockerfile#CMD
  Scenario: A container started without arguments serves the stock nginx welcome page on port 80
    Given the operator supplies no configuration or command of their own
    When the operator starts the container
    Then nginx runs in the foreground as the container's main process under dumb-init
    And a request to http://localhost/ answers 200 with the stock "Welcome to nginx!" page
    And ports 80 and 443 are declared as exposed

  @id:nginx.distribution.amazon-linux-images.018 @rule:operations.health.healthcheck-probes-localhost @inferred @source:nginx/1.19.1/amazonlinux/2.0.20200722.0/Dockerfile#HEALTHCHECK @questionable
  Scenario Outline: The container is healthy only while http://localhost/ answers without an error
    Given the container is serving with <setup>
    When the container runtime runs the built-in health check
    Then the check requests http://localhost/ every 30 seconds with a 3 second timeout
    And the container is reported as <health>

    Examples:
      | setup                                          | health    |
      | the default configuration                      | healthy   |
      | a configuration whose / location returns 404   | unhealthy |
      | a configuration that listens only on port 8080 | unhealthy |

  @id:nginx.distribution.amazon-linux-images.019 @rule:operations.logging.access-and-error-to-stdio @inferred @source:nginx/1.19.1/amazonlinux/2.0.20200722.0/Dockerfile#RUN
  Scenario: Access and error logs show up in the container's output streams
    Given nginx uses the default log paths
    When a client requests a page from the container
    Then the access log line appears on the container's stdout
    And nginx error messages appear on the container's stderr

  @id:nginx.distribution.amazon-linux-images.021 @rule:container.default-config.unprivileged-nginx-user @inferred @source:nginx/1.19.1/amazonlinux/2.0.20200722.0/Dockerfile#RUN
  Scenario: nginx workers run as the unprivileged nginx user with a fixed uid and gid
    Given nginx uses the default configuration
    When the operator starts the container
    Then worker processes run as user "nginx" with uid 32548 and group "nginx" with gid 32548
    And the nginx user has no login shell (/bin/false) and no home directory (/nonexistent)

  @id:nginx.distribution.amazon-linux-images.022 @rule:distribution.architectures.amazonlinux-1-19-1-amd64-only @inferred @source:nginx/1.19.1/amazonlinux/2.0.20200722.0/Dockerfile#RUN @questionable
  Scenario Outline: The nginx 1.19.1 Amazon Linux images only start on amd64
    Given the image was built on a <arch> host
    When the operator starts the container
    Then <outcome>

    Examples:
      | arch  | outcome                                                         |
      | amd64 | nginx starts under dumb-init                                    |
      | arm64 | dumb-init cannot run (exec format error) and nginx never starts |
