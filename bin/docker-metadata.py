#!/usr/bin/env python3
"""
Generate metadata documentation for nginx-lua Docker images.

This script generates metadata documentation for Docker images by pulling them
from the registry and extracting their inspection information. It creates
markdown files with JSON metadata for both nginx mainline and stable versions.
"""

import sys
import argparse
import common

def main():
    parser = argparse.ArgumentParser(description="Generate metadata documentation for nginx-lua Docker images")
    parser.add_argument(
        "os_distro",
        help="Operating system distribution (e.g., alpine, ubuntu, debian, fedora)"
    )
    args = parser.parse_args()

    os_distro = args.os_distro

    versions = common.load_supported_versions()

    tag = "%s-%s%s" % (versions["nginx_mainline"], os_distro, versions[os_distro])
    exit_code = common.generate_metadata(tag)
    if exit_code > 0:
        sys.exit(1)

    tag = "%s-%s%s" % (versions["nginx_stable"], os_distro, versions[os_distro])
    exit_code = common.generate_metadata(tag)
    if exit_code > 0:
        sys.exit(1)

if __name__ == "__main__":
    main()