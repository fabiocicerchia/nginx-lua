@domain:image-catalog @area:image-definitions @from:bin/generate-dockerfiles
Feature: Generating per-distro image definitions
  Gives maintainers one Dockerfile per supported nginx release and Linux distribution, so every published image tag is built from a definition that pins its nginx, OS and module versions.

  Background:
    Given the supported versions list names nginx mainline 1.31.8, nginx stable 1.30.6 and one release for each of almalinux, alpine, amazonlinux, debian, fedora and ubuntu

  @id:bin.image-catalog.image-definitions.003 @rule:images.definitions.mainline-and-stable-per-distro @inferred @source:bin/generate-dockerfiles.py#main
  Scenario Outline: Every supported distribution gets a mainline and a stable image definition
    Given the supported release of <distro> is <distro_version>
    When the maintainer generates the Dockerfiles
    Then a definition exists at nginx/1.31.8/<distro>/<distro_version>/Dockerfile
    And a definition exists at nginx/1.30.6/<distro>/<distro_version>/Dockerfile
    And each definition is built from the <distro> template

    Examples:
      | distro      | distro_version     |
      | almalinux   | 10.2-20261027      |
      | alpine      | 3.24.3             |
      | amazonlinux | 2023.12.20261102.0 |
      | debian      | 13.7               |
      | fedora      | 45                 |
      | ubuntu      | 26.04              |

  @id:bin.image-catalog.image-definitions.004 @rule:images.definitions.versions-pinned-in-definition @inferred @source:bin/common.py#patch_dockerfile
  Scenario: Each image definition pins its image name, OS release, nginx version and module versions
    Given the dependency versions file pins lua-nginx-module to a release
    When the maintainer generates the Dockerfiles
    Then the alpine 3.24.3 mainline definition declares DISTRO alpine and DISTRO_VER 3.24.3
    And it declares DOCKER_IMAGE fabiocicerchia/nginx-lua and VER_NGINX 1.31.8
    And it declares VER_LUA_NGINX_MODULE as the pinned lua-nginx-module release
    And no {{...}} placeholder for a known value is left in the definition

  @id:bin.image-catalog.image-definitions.005 @rule:images.definitions.build-context-bundled @inferred @source:bin/common.py#setup_dockerfile
  Scenario: Each image definition comes with the entrypoint scripts, nginx config, patches and third-party licences it builds from
    Given the shared sources contain entrypoint scripts, default.conf, nginx.conf, a Makefile, patches and licence files
    When the maintainer generates the Dockerfiles
    Then the tpl folder next to each definition holds every shared .sh script, executable by owner and group
    And it holds default.conf, nginx.conf and the Makefile
    And it holds every .patch file under patches and every .LICENSE file under licenses

  @id:bin.image-catalog.image-definitions.006 @rule:images.definitions.local-resolvers-script-not-shipped @inferred @source:bin/common.py#setup_dockerfile @questionable
  Scenario: The local-resolvers entrypoint script is not included in generated image definitions
    Given the shared sources contain the entrypoint script 15-local-resolvers.envsh
    When the maintainer generates the Dockerfiles
    Then the tpl folder of each definition does not contain 15-local-resolvers.envsh
    And images built from it have no local-resolvers step in /docker-entrypoint.d

  @id:bin.image-catalog.image-definitions.007 @rule:images.definitions.root-dockerfile-is-newest-alpine @inferred @source:bin/generate-dockerfiles.py#main @questionable
  Scenario: The repository's root Dockerfile is the newest alpine image definition
    Given generated alpine definitions exist for nginx 1.31.8 on alpine 3.24.3 and for older nginx releases
    When the maintainer generates the Dockerfiles
    Then the root Dockerfile is a copy of nginx/1.31.8/alpine/3.24.3/Dockerfile
