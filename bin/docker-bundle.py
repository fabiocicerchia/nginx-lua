#!/usr/bin/env python3
"""
Create multi-architecture Docker manifests for nginx-lua images.

This script creates multi-architecture Docker manifests that combine amd64 and
arm64v8 images into a single manifest. It bundles both nginx mainline and stable
versions for the specified operating system distribution.
"""

import argparse
import common


def main():
    parser = argparse.ArgumentParser(
        description="Create multi-arch Docker manifests for nginx-lua images"
    )
    parser.add_argument(
        "os_distro", help="Operating system distribution (e.g., alpine, ubuntu, debian)"
    )
    args = parser.parse_args()

    os_distro = args.os_distro

    versions = common.load_supported_versions()

    common.for_mainline_and_stable(common.bundle_images, versions, os_distro)


if __name__ == "__main__":
    main()
