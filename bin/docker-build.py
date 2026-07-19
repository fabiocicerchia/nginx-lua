#!/usr/bin/env python3
"""
Build Docker images for nginx-lua.

This script builds Docker images for the specified operating system distribution
and architecture. It builds both nginx mainline and stable versions for the
given OS distribution.
"""

import sys
import subprocess
import common
import argparse

ARM64_ARCH = "arm64"

def main():
    parser = argparse.ArgumentParser(description="Build Docker images for nginx-lua")
    parser.add_argument(
        "os_distro",
        help="Operating system distribution (e.g., alpine, ubuntu, debian)"
    )
    parser.add_argument(
        "arch",
        help="Architecture (amd64 or arm64)"
    )
    args = parser.parse_args()

    os_distro = args.os_distro
    arch = args.arch

    if arch == ARM64_ARCH:
        arch = common.ARM64V8_ARCH

    versions = common.load_supported_versions()

    exit_code = common.build_image(
        versions["nginx_mainline"], os_distro, versions[os_distro], arch
    )
    if exit_code > 0:
        sys.exit(1)

    exit_code = common.build_image(
        versions["nginx_stable"], os_distro, versions[os_distro], arch
    )
    if exit_code > 0:
        sys.exit(1)

    stdout = subprocess.check_output(
        common.DOCKER_IMAGES_COMMAND.split(), text=True
    )
    print(stdout)

if __name__ == "__main__":
    main()