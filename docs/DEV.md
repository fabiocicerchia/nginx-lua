# DEV

```console
$ make
              __                     __
.-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
|     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
|__|__|___  ||__||__|__|__.__|      |__||_____|___._|
      |_____|

Copyright (c) 2022 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
Repo: https://github.com/fabiocicerchia/nginx-lua

Use: make <target>

GENERIC
  all                             build, test and push everything
  help                            prints this help

BUILD
  build-all                       build all dockerfiles
  build-alpine                    build one distro
  build-amazonlinux               build one distro
  build-debian                    build one distro
  build-fedora                    build one distro
  build-ubuntu                    build one distro

BUILD MINIMAL
  build-minimal-all               build all dockerfiles (minimal)
  build-minimal-alpine            build one distro (minimal)
  build-minimal-amazonlinux       build one distro (minimal)
  build-minimal-debian            build one distro (minimal)
  build-minimal-fedora            build one distro (minimal)
  build-minimal-ubuntu            build one distro (minimal)

TESTING
  test-all                        test all docker images
  test-alpine                     test one docker image
  test-amazonlinux                test one docker image
  test-debian                     test one docker image
  test-fedora                     test one docker image
  test-ubuntu                     test one docker image
  test-security                   test security all docker images
  test-security-alpine            test security one docker images
  test-security-amazonlinux       test security one docker images
  test-security-debian            test security one docker images
  test-security-fedora            test security one docker images
  test-security-ubuntu            test security one docker images

PUSH
  push-all                        push all docker images to docker hub
  push-alpine                     push one docker images to docker hub
  push-amazonlinux                push one docker images to docker hub
  push-debian                     push one docker images to docker hub
  push-fedora                     push one docker images to docker hub
  push-ubuntu                     push one docker images to docker hub

UTILITIES
  auto-update                     auto update supported versions, dockerfiles and tags
  tag                             create a git tag
  release                         create a github release
  generate-supported-versions     generate supported_versions file
  generate-dockerfiles            generate all dockerfiles
  generate-metadata               generate all metadata for docker images
  update-tags                     update docker tags file
  update-readme                   update supported docker tags in readme
  benchmark                       benchmark (wip)
  changelog                       generate a changelog since previous tag
```

## How to add a new supported OS

Create two different files:

- `tpl/Dockerfile.XXX`
- `tpl/Dockerfile.XXX-compat`

The `compat` version is meant for having a compiled version of the LUA code, the main difference is in the section `Build Nginx with support for LUA` which has got `make lua-src` before actually building `deps` and `core`.

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

### Differences between standard vs compat

- Extra env var `LUA_INCDIR=$LUAJIT_INC`
- No dependency on system packages `lua-${VER_LUA}` and `lua-devel-${VER_LUA}` and `luarocks`
- Extra step for building lua from source: `make -j "$(nproc)" lua-src`
- Extra step for building luarocks from source: `make luarocks`
- Copying the binaries `lua`, `luajit`, `luarocks` and the whole `LUA_INCDIR` folder from the multistage build
- Avoiding to symlink the `lua` binary
