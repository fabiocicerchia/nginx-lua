@domain:distribution @area:rhel-family-images @from:1-19-2/fedora
Feature: Fedora images of nginx 1.19.2 with Lua
  Operators who standardise on Fedora get nginx 1.19.2 with Lua support on Fedora 32, 33 or 34, and can tell from the image itself which nginx, OS and modules they are running.

  Background:
    Given the published image fabiocicerchia/nginx-lua for nginx 1.19.2 on Fedora

  @id:nginx.distribution.rhel-family-images.033 @rule:distribution.fedora.image-declares-nginx-and-os-version @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#base
  Scenario Outline: Each Fedora image states the nginx and Fedora release it was built from
    Given the operator has pulled the Fedora <fedora> variant
    When the operator inspects the image labels
    Then the label org.label-schema.version reads "<version>"
    And the label versions.nginx reads "1.19.2"
    And the label versions.os reads "<fedora>"
    And the description reads "Nginx 1.19.2 with Lua support based on fedora <fedora>."

    Examples:
      | fedora | version         |
      | 32     | 1.19.2-fedora32 |
      | 33     | 1.19.2-fedora33 |
      | 34     | 1.19.2-fedora34 |

  @id:nginx.distribution.rhel-family-images.034 @rule:distribution.fedora.lua-upstream-only-on-newer-releases @inferred @source:nginx/1.19.2/fedora/33/Dockerfile#builder @questionable
  Scenario Outline: Lua upstream inspection is available on Fedora 33 and 34 but not on Fedora 32
    Given the operator runs the Fedora <fedora> variant
    When the operator inspects the image labels and the compiled nginx modules
    Then the lua-upstream module is <presence>
    And the label versions.lua-upstream is <label>

    Examples:
      | fedora | presence    | label  |
      | 32     | absent      | absent |
      | 33     | compiled in | "0.07" |
      | 34     | compiled in | "0.07" |

  @id:nginx.distribution.rhel-family-images.035 @rule:distribution.fedora.extended-build-falls-back-to-plain-nginx @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#builder @questionable
  Scenario: An extended image whose extra modules fail to configure ships without them instead of failing
    Given the image is built as an extended image
    And the headers-more or stream-lua module cannot be configured into nginx
    When the maintainer builds the Fedora image
    Then the build completes
    And nginx in the image has Lua support but no more_set_headers and no stream Lua directives
    And the label versions.extended still reads "1"

  @id:nginx.distribution.rhel-family-images.036 @rule:distribution.fedora.workers-run-as-unprivileged-nginx-user @inferred @source:nginx/1.19.2/fedora/32/Dockerfile#base
  Scenario: nginx workers run as the unprivileged nginx user with a fixed id
    Given the container is running with the default command
    When the operator lists the nginx worker processes
    Then the workers run as user "nginx" with uid 32548 and gid 32548
    And the nginx user has no login shell and no home directory
