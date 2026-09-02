#!/usr/bin/env python3
"""
Build Docker images for nginx-lua.

This script builds Docker images for the specified operating system distribution
and architecture. It builds both nginx mainline and stable versions for the
given OS distribution.
"""

import subprocess
import common
import docker_ops
import argparse

ARM64_ARCH = "arm64"


def main():
    parser = argparse.ArgumentParser(description="Build Docker images for nginx-lua")
    parser.add_argument(
        "os_distro", help="Operating system distribution (e.g., alpine, ubuntu, debian)"
    )
    parser.add_argument("arch", help="Architecture (amd64 or arm64)")
    args = parser.parse_args()

    os_distro = args.os_distro
    arch = args.arch

    if arch == ARM64_ARCH:
        arch = docker_ops.ARM64V8_ARCH

    versions = common.load_supported_versions()

    common.for_mainline_and_stable(docker_ops.build_image, versions, os_distro, arch)

    stdout = subprocess.check_output(
        docker_ops.DOCKER_IMAGES_COMMAND.split(), text=True
    )
    print(stdout)


if __name__ == "__main__":
    main()
