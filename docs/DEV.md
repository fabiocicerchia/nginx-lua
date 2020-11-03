# DEV

```console
$ make
              __                     __
.-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
|     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
|__|__|___  ||__||__|__|__.__|      |__||_____|___._|
      |_____|

Copyright (c) 2020 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
Repo: https://github.com/fabiocicerchia/nginx-lua

Use: make <target>

GENERIC
  all                             build, test and push everything
  help                            prints this help

BUILD
  build-all                       build all dockerfiles
  build-alpine                    build one distro
  build-amazonlinux               build one distro
  build-centos                    build one distro
  build-debian                    build one distro
  build-fedora                    build one distro
  build-ubuntu                    build one distro

BUILD MINIMAL
  build-minimal-all               build all dockerfiles (minimal)
  build-minimal-alpine            build one distro (minimal)
  build-minimal-amazonlinux       build one distro (minimal)
  build-minimal-centos            build one distro (minimal)
  build-minimal-debian            build one distro (minimal)
  build-minimal-fedora            build one distro (minimal)
  build-minimal-ubuntu            build one distro (minimal)

TESTING
  test-all                        test all docker images
  test-alpine                     test one docker image
  test-amazonlinux                test one docker image
  test-centos                     test one docker image
  test-debian                     test one docker image
  test-fedora                     test one docker image
  test-ubuntu                     test one docker image
  test-security                   test security all docker images
  test-security-alpine            test security one docker images
  test-security-amazonlinux       test security one docker images
  test-security-centos            test security one docker images
  test-security-debian            test security one docker images
  test-security-fedora            test security one docker images
  test-security-ubuntu            test security one docker images

PUSH
  push-all                        push all docker images to docker hub
  push-alpine                     push one docker images to docker hub
  push-amazonlinux                push one docker images to docker hub
  push-centos                     push one docker images to docker hub
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
