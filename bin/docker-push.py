#!/usr/bin/env python3
"""
Push Docker images to registry for nginx-lua.

This script pushes Docker images to the Docker registry for the specified
operating system distribution. It pushes both nginx mainline and stable
versions for the given OS distribution.
"""

import platform
import common
import docker_ops
import argparse

# Map platform.machine() values to Docker architecture names
_MACHINE_TO_ARCH = {
    "x86_64": docker_ops.AMD64_ARCH,
    "aarch64": docker_ops.ARM64V8_ARCH,
}


def detect_arch():
    """Return the Docker architecture name for the current machine."""
    machine = platform.machine()
    arch = _MACHINE_TO_ARCH.get(machine)
    if arch is None:
        print(
            f"WARNING: Unknown machine type '{machine}', will push for all architectures"
        )
    return arch


def main():
    parser = argparse.ArgumentParser(
        description="Push Docker images to registry for nginx-lua"
    )
    parser.add_argument(
        "os_distro",
        help="Operating system distribution (e.g., alpine, ubuntu, debian, fedora)",
    )
    args = parser.parse_args()

    os_distro = args.os_distro
    arch = detect_arch()

    versions = common.load_supported_versions()

    common.for_mainline_and_stable(docker_ops.push_images, versions, os_distro, arch)


if __name__ == "__main__":
    main()
