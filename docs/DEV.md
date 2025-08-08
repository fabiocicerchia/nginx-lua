# DEV

```console
$ make
              __                     __ 
.-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
|     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
|__|__|___  ||__||__|__|__.__|      |__||_____|___._|
      |_____|

Copyright (c) 2025 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
Repo: https://github.com/fabiocicerchia/nginx-lua

Use: make <target>

GENERIC
  all                                                 build, test and push everything
  help                                                prints this help

BUILD
  build-all                                           build all dockerfiles
  build-amd64                                         build all distros in amd64 arch
  build-arm64                                         build all distros in arm64/v8 arch
  build-amd64-almalinux                               build one distro in amd64 arch  
  build-amd64-alpine                                  build one distro in amd64 arch  
  build-amd64-amazonlinux                             build one distro in amd64 arch  
  build-amd64-debian                                  build one distro in amd64 arch  
  build-amd64-fedora                                  build one distro in amd64 arch  
  build-amd64-ubuntu                                  build one distro in amd64 arch
  build-arm64-almalinux                               build one distro in arm64/v8 arch  
  build-arm64-alpine                                  build one distro in arm64/v8 arch  
  build-arm64-amazonlinux                             build one distro in arm64/v8 arch  
  build-arm64-debian                                  build one distro in arm64/v8 arch  
  build-arm64-fedora                                  build one distro in arm64/v8 arch  
  build-arm64-ubuntu                                  build one distro in arm64/v8 arch

TESTING
  test-all                                            test all docker images
  docker-test-amd64-almalinux                         test one docker image  
  docker-test-amd64-alpine                            test one docker image  
  docker-test-amd64-amazonlinux                       test one docker image  
  docker-test-amd64-debian                            test one docker image  
  docker-test-amd64-fedora                            test one docker image  
  docker-test-amd64-ubuntu                            test one docker image  
  docker-test-arm64-almalinux                         test one docker image  
  docker-test-arm64-alpine                            test one docker image  
  docker-test-arm64-amazonlinux                       test one docker image  
  docker-test-arm64-debian                            test one docker image  
  docker-test-arm64-fedora                            test one docker image  
  docker-test-arm64-ubuntu                            test one docker image
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

PACKAGE
  packages                                            creating the system package .apk (Alpine), .deb (Debian-like), .rpm (RHEL-like)
  package-amd64-almalinux                             creating the system package in amd64 arch  
  package-amd64-alpine                                creating the system package in amd64 arch  
  package-amd64-amazonlinux                           creating the system package in amd64 arch  
  package-amd64-debian                                creating the system package in amd64 arch  
  package-amd64-fedora                                creating the system package in amd64 arch  
  package-amd64-ubuntu                                creating the system package in amd64 arch
  package-arm64-almalinux                             creating the system package in arm64/v8 arch  
  package-arm64-alpine                                creating the system package in arm64/v8 arch  
  package-arm64-amazonlinux                           creating the system package in arm64/v8 arch  
  package-arm64-debian                                creating the system package in arm64/v8 arch  
  package-arm64-fedora                                creating the system package in arm64/v8 arch  
  package-arm64-ubuntu                                creating the system package in arm64/v8 arch
  package-test                                        testing installation of the system package .apk (Alpine), .deb (Debian-like), .rpm (RHEL-like)
  package-test-amd64-almalinux                        testing the system package in amd64 arch  
  package-test-amd64-alpine                           testing the system package in amd64 arch  
  package-test-amd64-amazonlinux                      testing the system package in amd64 arch  
  package-test-amd64-debian                           testing the system package in amd64 arch  
  package-test-amd64-fedora                           testing the system package in amd64 arch  
  package-test-amd64-ubuntu                           testing the system package in amd64 arch
  package-test-arm64-almalinux                        testing the system package in arm64/v8 arch  
  package-test-arm64-alpine                           testing the system package in arm64/v8 arch  
  package-test-arm64-amazonlinux                      testing the system package in arm64/v8 arch  
  package-test-arm64-debian                           testing the system package in arm64/v8 arch  
  package-test-arm64-fedora                           testing the system package in arm64/v8 arch  
  package-test-arm64-ubuntu                           testing the system package in arm64/v8 arch

UTILITIES
  auto-update                                         auto update supported versions, dockerfiles and tags
  release                                             create a github release
  generate-supported-versions                         generate supported_versions file
  generate-dockerfiles                                generate all dockerfiles
  generate-deps-env                                   generate .env for dependencies
  pull-nginx-entrypoints                              retrieves the official entrypoint files
  generate-metadata                                   generate metadata for all OS docker images
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

## How to build ARM on AMD

Run the following command:

```console
$ make qemu
```

<details>
```
From github.com:fabiocicerchia/nginx-lua
 * branch            main       -> FETCH_HEAD
docker buildx create --name multiarch --use
multiarch
sudo apt-get update
[sudo] password for fabio:
Get:1 http://security.ubuntu.com/ubuntu jammy-security InRelease [110 kB]
Hit:2 https://download.docker.com/linux/ubuntu jammy InRelease
Hit:3 http://it.archive.ubuntu.com/ubuntu jammy InRelease
Hit:4 https://dl.google.com/linux/chrome/deb stable InRelease
Get:5 http://it.archive.ubuntu.com/ubuntu jammy-updates InRelease [119 kB]
Get:7 http://it.archive.ubuntu.com/ubuntu jammy-backports InRelease [109 kB]
Get:8 http://security.ubuntu.com/ubuntu jammy-security/main amd64 Packages [938 kB]
Hit:6 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Get:9 http://it.archive.ubuntu.com/ubuntu jammy-updates/main i386 Packages [523 kB]
Get:10 http://security.ubuntu.com/ubuntu jammy-security/main amd64 DEP-11 Metadata [43,1 kB]
Get:11 http://security.ubuntu.com/ubuntu jammy-security/main amd64 c-n-f Metadata [11,4 kB]
Get:12 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 Packages [796 kB]
Get:13 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 DEP-11 Metadata [55,1 kB]  
Get:14 http://it.archive.ubuntu.com/ubuntu jammy-updates/main amd64 Packages [1.148 kB]
Get:15 http://it.archive.ubuntu.com/ubuntu jammy-updates/main Translation-en [245 kB]
Get:16 http://it.archive.ubuntu.com/ubuntu jammy-updates/main amd64 DEP-11 Metadata [101 kB]
Get:17 http://it.archive.ubuntu.com/ubuntu jammy-updates/restricted amd64 Packages [1.103 kB]
Get:18 http://it.archive.ubuntu.com/ubuntu jammy-updates/restricted Translation-en [179 kB]
Get:19 http://it.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 DEP-11 Metadata [305 kB]
Get:20 http://it.archive.ubuntu.com/ubuntu jammy-updates/multiverse amd64 DEP-11 Metadata [940 B]
Get:21 http://it.archive.ubuntu.com/ubuntu jammy-backports/main amd64 DEP-11 Metadata [4.936 B]
Get:22 http://it.archive.ubuntu.com/ubuntu jammy-backports/universe amd64 DEP-11 Metadata [18,9 kB]
Fetched 5.810 kB in 3s (1.830 kB/s)
Reading package lists... Done
sudo apt-get install --force-yes qemu binfmt-support qemu-user-static # Install the qemu packages
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed
  binfmt-support qemu qemu-user-static
0 to upgrade, 3 to newly install, 0 to remove and 23 not to upgrade.
Need to get 13,0 MB of archives.
After this operation, 130 MB of additional disk space will be used.
Get:1 http://it.archive.ubuntu.com/ubuntu jammy/main amd64 binfmt-support amd64 2.2.1-2 [55,8 kB]
Get:2 http://it.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 qemu amd64 1:6.2+dfsg-2ubuntu6.15 [13,9 kB]
Get:3 http://it.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 qemu-user-static amd64 1:6.2+dfsg-2ubuntu6.15 [13,0 MB]
Fetched 13,0 MB in 3s (4.629 kB/s)
Selecting previously unselected package binfmt-support.
(Reading database ... 286224 files and directories currently installed.)
Preparing to unpack .../binfmt-support_2.2.1-2_amd64.deb ...
Unpacking binfmt-support (2.2.1-2) ...
Selecting previously unselected package qemu.
Preparing to unpack .../qemu_1%3a6.2+dfsg-2ubuntu6.15_amd64.deb ...
Unpacking qemu (1:6.2+dfsg-2ubuntu6.15) ...
Selecting previously unselected package qemu-user-static.
Preparing to unpack .../qemu-user-static_1%3a6.2+dfsg-2ubuntu6.15_amd64.deb ...
Unpacking qemu-user-static (1:6.2+dfsg-2ubuntu6.15) ...
Setting up qemu (1:6.2+dfsg-2ubuntu6.15) ...
Setting up qemu-user-static (1:6.2+dfsg-2ubuntu6.15) ...
Setting up binfmt-support (2.2.1-2) ...
update-binfmts: warning: python3.10 already enabled in kernel.
Created symlink /etc/systemd/system/multi-user.target.wants/binfmt-support.service → /lib/systemd/system/binfmt-support.service.
Processing triggers for man-db (2.10.2-1) ...
W: --force-yes is deprecated, use one of the options starting with --allow instead.
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes # This step will execute the registering scripts
Unable to find image 'multiarch/qemu-user-static:latest' locally
latest: Pulling from multiarch/qemu-user-static
205dae5015e7: Pull complete
816739e52091: Pull complete
30abb83a18eb: Pull complete
0657daef200b: Pull complete
30c9c93f40b9: Pull complete
Digest: sha256:fe60359c92e86a43cc87b3d906006245f77bfc0565676b80004cc666e4feb9f0
Status: Downloaded newer image for multiarch/qemu-user-static:latest
Setting /usr/bin/qemu-alpha-static as binfmt interpreter for alpha
Setting /usr/bin/qemu-arm-static as binfmt interpreter for arm
Setting /usr/bin/qemu-armeb-static as binfmt interpreter for armeb
Setting /usr/bin/qemu-sparc-static as binfmt interpreter for sparc
Setting /usr/bin/qemu-sparc32plus-static as binfmt interpreter for sparc32plus
Setting /usr/bin/qemu-sparc64-static as binfmt interpreter for sparc64
Setting /usr/bin/qemu-ppc-static as binfmt interpreter for ppc
Setting /usr/bin/qemu-ppc64-static as binfmt interpreter for ppc64
Setting /usr/bin/qemu-ppc64le-static as binfmt interpreter for ppc64le
Setting /usr/bin/qemu-m68k-static as binfmt interpreter for m68k
Setting /usr/bin/qemu-mips-static as binfmt interpreter for mips
Setting /usr/bin/qemu-mipsel-static as binfmt interpreter for mipsel
Setting /usr/bin/qemu-mipsn32-static as binfmt interpreter for mipsn32
Setting /usr/bin/qemu-mipsn32el-static as binfmt interpreter for mipsn32el
Setting /usr/bin/qemu-mips64-static as binfmt interpreter for mips64
Setting /usr/bin/qemu-mips64el-static as binfmt interpreter for mips64el
Setting /usr/bin/qemu-sh4-static as binfmt interpreter for sh4
Setting /usr/bin/qemu-sh4eb-static as binfmt interpreter for sh4eb
Setting /usr/bin/qemu-s390x-static as binfmt interpreter for s390x
Setting /usr/bin/qemu-aarch64-static as binfmt interpreter for aarch64
Setting /usr/bin/qemu-aarch64_be-static as binfmt interpreter for aarch64_be
Setting /usr/bin/qemu-hppa-static as binfmt interpreter for hppa
Setting /usr/bin/qemu-riscv32-static as binfmt interpreter for riscv32
Setting /usr/bin/qemu-riscv64-static as binfmt interpreter for riscv64
Setting /usr/bin/qemu-xtensa-static as binfmt interpreter for xtensa
Setting /usr/bin/qemu-xtensaeb-static as binfmt interpreter for xtensaeb
Setting /usr/bin/qemu-microblaze-static as binfmt interpreter for microblaze
Setting /usr/bin/qemu-microblazeel-static as binfmt interpreter for microblazeel
Setting /usr/bin/qemu-or1k-static as binfmt interpreter for or1k
Setting /usr/bin/qemu-hexagon-static as binfmt interpreter for hexagon
```
</details>

Then run any command for building on ARM, e.g. `make build-arm64-fedora`.
