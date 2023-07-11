# DEV

```console
$ make
              __                     __
.-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
|     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
|__|__|___  ||__||__|__|__.__|      |__||_____|___._|
      |_____|

Copyright (c) 2023 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
Repo: https://github.com/fabiocicerchia/nginx-lua

Use: make <target>

GENERIC
  all                                                 build, test and push everything
  help                                                prints this help

BUILD
  build-all                                           build all dockerfiles
  build-amd64                                         build all distros in amd64 arch
  build-arm64                                         build all distros in arm64 arch
  build-amd64-almalinux-classic                       build one distro in amd64 arch
  build-amd64-alpine-classic                          build one distro in amd64 arch
  build-amd64-amazonlinux-classic                     build one distro in amd64 arch
  build-amd64-debian-classic                          build one distro in amd64 arch
  build-amd64-fedora-classic                          build one distro in amd64 arch
  build-amd64-ubuntu-classic                          build one distro in amd64 arch
  build-arm64v8-almalinux-classic                     build one distro in arm64/v8 arch
  build-arm64v8-alpine-classic                        build one distro in arm64/v8 arch
  build-arm64v8-amazonlinux-classic                   build one distro in arm64/v8 arch
  build-arm64v8-debian-classic                        build one distro in arm64/v8 arch
  build-arm64v8-fedora-classic                        build one distro in arm64/v8 arch
  build-arm64v8-ubuntu-classic                        build one distro in arm64/v8 arch
  build-arm.medium-almalinux-classic                  build one distro in one arch (CircleCI internals)
  build-arm.medium-alpine-classic                     build one distro in one arch (CircleCI internals)
  build-arm.medium-amazonlinux-classic                build one distro in one arch (CircleCI internals)
  build-arm.medium-debian-classic                     build one distro in one arch (CircleCI internals)
  build-arm.medium-fedora-classic                     build one distro in one arch (CircleCI internals)
  build-arm.medium-ubuntu-classic                     build one distro in one arch (CircleCI internals)
  build-large-almalinux-classic                       build one distro in one arch (CircleCI internals)
  build-large-alpine-classic                          build one distro in one arch (CircleCI internals)
  build-large-amazonlinux-classic                     build one distro in one arch (CircleCI internals)
  build-large-debian-classic                          build one distro in one arch (CircleCI internals)
  build-large-fedora-classic                          build one distro in one arch (CircleCI internals)
  build-large-ubuntu-classic                          build one distro in one arch (CircleCI internals)

TESTING
  test-all                                            test all docker images
  test-almalinux                                      test one docker image
  test-alpine                                         test one docker image
  test-amazonlinux                                    test one docker image
  test-debian                                         test one docker image
  test-fedora                                         test one docker image
  test-ubuntu                                         test one docker image
  test-security                                       test security all docker images
  test-security-almalinux                             test security one docker images
  test-security-alpine                                test security one docker images
  test-security-amazonlinux                           test security one docker images
  test-security-debian                                test security one docker images
  test-security-fedora                                test security one docker images
  test-security-ubuntu                                test security one docker images

PUSH
  push-all                                            push all docker images to docker hub
  push-almalinux                                      push one docker images to docker hub
  push-alpine                                         push one docker images to docker hub
  push-amazonlinux                                    push one docker images to docker hub
  push-debian                                         push one docker images to docker hub
  push-fedora                                         push one docker images to docker hub
  push-ubuntu                                         push one docker images to docker hub

BUNDLE
  bundle-almalinux                                    bundle multiple docker images into one
  bundle-alpine                                       bundle multiple docker images into one
  bundle-amazonlinux                                  bundle multiple docker images into one
  bundle-debian                                       bundle multiple docker images into one
  bundle-fedora                                       bundle multiple docker images into one
  bundle-ubuntu                                       bundle multiple docker images into one

DEPENDENCIES

UTILITIES
  auto-update                                         auto update supported versions, dockerfiles and tags
  release                                             create a github release
  generate-supported-versions                         generate supported_versions file
  generate-dockerfiles                                generate all dockerfiles
  generate-metadata                                   generate metadata for all OS docker images
  generate-metadata-all                               generate all metadata for all OS docker images
  update-tags                                         update docker tags file
  update-readme                                       update supported docker tags in readme
  benchmark                                           benchmark (wip)
  changelog                                           generate a changelog since previous tag

```

## How to add a new supported OS

Create two different files:

- `tpl/Dockerfile.XXX`

Customise the shell script to use the new distro:

- Clone the relative alpine sections to match the new distro, then run `make generate-supported-versions`
- Add in the top-level `Makefile` the new distro name in the variable `DISTROS`
- Add a case in the `get_versions` function in `bin/_common.sh`
- Add the distro in the `loop_over_nginx` function in `bin/_common.sh`
- Add the distro in the `docker_build.strategy.matrix` in `.github/workflows/main.yml`

Once added those two files generates the static Dockerfiles in the `nginx` folder by running the command `make generate-dockerfiles`.

Do not forget to update the README to include the distro in the list:

- Run `make update-tags` and `make update-readme` to include the new distro tags in the documentation
- Add the new distro in the support comparison table with OpenResty

## Build locally

The flag `FORCE` is needed most of the times, because if there are no changes in the environment to
any dockerfile in the last commit the flag `SKIP` will be set in the `Makefile`.

```bash
FORCE=YES make build-all
FORCE=YES make test-all
```

## Minimal Image

The extended image (default one) contains a set of extra packages for enhanced functionality.
If you need a smaller version, like the official distros (containing only nginx and openresty's lua module),
you could build changing the Makefile settings `EXTENDED_IMAGE` to `NO`.
