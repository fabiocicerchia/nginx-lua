#!/usr/bin/env python3
"""
Promote unsigned Docker images to final tags after signing.

This script copies signed -unsigned images to their final tag names
in the registry, for the specified OS distribution.
"""

import platform
import sys
import common
import argparse

# Map platform.machine() values to Docker architecture names
_MACHINE_TO_ARCH = {
    "x86_64": common.AMD64_ARCH,
    "aarch64": common.ARM64V8_ARCH,
}


def detect_arch():
    """Return the Docker architecture name for the current machine."""
    machine = platform.machine()
    arch = _MACHINE_TO_ARCH.get(machine)
    if arch is None:
        print(f"WARNING: Unknown machine type '{machine}', will promote for all architectures")
    return arch


def main():
    parser = argparse.ArgumentParser(description="Promote signed Docker images to final tags")
    parser.add_argument(
        "os_distro",
        help="Operating system distribution (e.g., alpine, ubuntu, debian, fedora)"
    )
    args = parser.parse_args()

    os_distro = args.os_distro
    arch = detect_arch()

    versions = common.load_supported_versions()

    exit_code = common.promote_images(versions["nginx_mainline"], os_distro, versions[os_distro], arch)
    if exit_code > 0:
        sys.exit(1)

    exit_code = common.promote_images(versions["nginx_stable"], os_distro, versions[os_distro], arch)
    if exit_code > 0:
        sys.exit(1)

if __name__ == "__main__":
    main()
