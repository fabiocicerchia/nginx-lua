@domain:container-startup @area:default-config @from:1-19-1/fedora
Feature: Default way the image runs
  Tells operators what the container runs out of the box and as which user, so mounted files and permissions line up across image variants.

  @id:nginx.container-startup.default-config.027 @rule:container.defaults.foreground-nginx-under-init @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#CMD
  Scenario: Without a command, the container runs nginx in the foreground
    Given the image 1.19.1-fedora32
    When the operator starts the container without a command
    Then nginx runs in the foreground with "daemon off"
    And dumb-init is process 1

  @id:nginx.container-startup.default-config.028 @rule:container.defaults.nginx-user-fixed-ids @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#NGINX_BUILD_CONFIG
  Scenario: nginx workers run as the nginx user with fixed IDs 32548
    Given the image 1.19.1-fedora32
    When the operator inspects the nginx user in the container
    Then the user nginx has uid 32548 and gid 32548
    And the user has no login shell and no home directory

  @id:nginx.container-startup.default-config.029 @rule:container.defaults.timezone-from-environment @inferred @source:nginx/1.19.1/fedora/32/Dockerfile#tzdata
  Scenario: The operator can set the container's timezone through the environment
    Given the image 1.19.1-fedora32
    When the operator starts the container with TZ set to Europe/Rome
    Then times written by the container use the Europe/Rome timezone
