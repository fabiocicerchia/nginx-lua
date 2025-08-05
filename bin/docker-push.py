#!/usr/bin/env python3
"""
Push Docker images to registry for nginx-lua.

This script pushes Docker images to the Docker registry for the specified
operating system distribution. It pushes both nginx mainline and stable
versions for the given OS distribution.
"""

import sys
import common
import argparse

def main():
    parser = argparse.ArgumentParser(description="Push Docker images to registry for nginx-lua")
    parser.add_argument(
        "os_distro",
        help="Operating system distribution (e.g., alpine, ubuntu, debian, fedora)"
    )
    args = parser.parse_args()

    os_distro = args.os_distro

    versions = common.load_supported_versions()

    exit_code = common.push_images(versions["nginx_mainline"], os_distro, versions[os_distro])
    if exit_code > 0:
        sys.exit(1)

    exit_code = common.push_images(versions["nginx_stable"], os_distro, versions[os_distro])
    if exit_code > 0:
        sys.exit(1)

if __name__ == "__main__":
    main()