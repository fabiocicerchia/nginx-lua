#!/usr/bin/env python3
"""
Promote unsigned Docker images to final tags after signing.

This script copies signed -unsigned images to their final tag names
in the registry, for the specified OS distribution.
"""

import sys
import common
import argparse

def main():
    parser = argparse.ArgumentParser(description="Promote signed Docker images to final tags")
    parser.add_argument(
        "os_distro",
        help="Operating system distribution (e.g., alpine, ubuntu, debian, fedora)"
    )
    args = parser.parse_args()

    os_distro = args.os_distro

    versions = common.load_supported_versions()

    exit_code = common.promote_images(versions["nginx_mainline"], os_distro, versions[os_distro])
    if exit_code > 0:
        sys.exit(1)

    exit_code = common.promote_images(versions["nginx_stable"], os_distro, versions[os_distro])
    if exit_code > 0:
        sys.exit(1)

if __name__ == "__main__":
    main()
