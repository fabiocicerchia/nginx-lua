@domain:distribution @area:rhel-family-images @from:1-19-0/fedora
Feature: Running nginx 1.19.0 with Lua on Fedora
  Gives operators who standardise on Fedora a ready nginx 1.19.0 + Lua image for each Fedora release from 29 to 33, with predictable runtime behaviour.

  Background:
    Given the operator has pulled a fabiocicerchia/nginx-lua 1.19.0 Fedora image

  @id:nginx.distribution.rhel-family-images.022 @rule:distribution.fedora-1-19-0.image-per-fedora-release @inferred @source:nginx/1.19.0/fedora/33/Dockerfile#base
  Scenario Outline: Each supported Fedora release has its own nginx 1.19.0 image
    Given the operator wants Fedora <fedora>
    When the operator inspects the image tagged 1.19.0-fedora<fedora>
    Then the image is built on fedora:<fedora>
    And its description reads "Nginx 1.19.0 with Lua support based on fedora <fedora>."
    And its suggested run command is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.19.0-fedora<fedora>"

    Examples:
      | fedora |
      | 29     |
      | 30     |
      | 31     |
      | 32     |
      | 33     |

  @id:nginx.distribution.rhel-family-images.023 @rule:distribution.fedora-1-19-0.extended-lua-libraries-on-recent-releases @inferred @source:nginx/1.19.0/fedora/33/Dockerfile#builder @questionable
  Scenario Outline: Only the Fedora 32 and 33 images include the extended Lua modules
    Given the image is for Fedora <fedora>
    When the operator loads a config that uses more_set_headers, a stream-level Lua block, or requires resty.redis
    Then the extended modules are <availability>

    Examples:
      | fedora | availability                                                                                                                                      |
      | 29     | not available: only the core Lua module, resty core and lrucache are included                                                                     |
      | 30     | not available: only the core Lua module, resty core and lrucache are included                                                                     |
      | 31     | not available: only the core Lua module, resty core and lrucache are included                                                                     |
      | 32     | available: headers-more, stream-lua and the cookie, dns, memcached, mysql, redis, shell, upstream-healthcheck, websocket and prometheus libraries |
      | 33     | available: headers-more, stream-lua and the cookie, dns, memcached, mysql, redis, shell, upstream-healthcheck, websocket and prometheus libraries |

  @id:nginx.distribution.rhel-family-images.024 @rule:distribution.fedora-1-19-0.stop-signal @inferred @source:nginx/1.19.0/fedora/33/Dockerfile#STOPSIGNAL @questionable
  Scenario Outline: Stopping the container sends nginx a release-dependent signal
    Given the image is for Fedora <fedora>
    And nginx is serving requests
    When the operator stops the container
    Then nginx receives <signal>
    And in-flight requests are <effect>

    Examples:
      | fedora | signal  | effect                                           |
      | 29     | SIGTERM | dropped by a fast shutdown                       |
      | 30     | SIGTERM | dropped by a fast shutdown                       |
      | 31     | SIGTERM | dropped by a fast shutdown                       |
      | 32     | SIGQUIT | finished before workers exit (graceful shutdown) |
      | 33     | SIGQUIT | finished before workers exit (graceful shutdown) |

  @id:nginx.distribution.rhel-family-images.025 @rule:distribution.fedora-1-19-0.healthcheck-and-ports @inferred @source:nginx/1.19.0/fedora/33/Dockerfile#HEALTHCHECK
  Scenario: The container reports healthy only while the local site answers
    Given the container is running and exposes ports 80 and 443
    When the container runtime runs its health check every 30 seconds
    Then the container is healthy if http://localhost/ answers with a success status within 3 seconds
    And the container is unhealthy if it answers with an error or does not answer in time
