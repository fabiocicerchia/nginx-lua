#!/usr/bin/env python3
"""
Generate metadata documentation for all nginx-lua Docker images.

This script generates metadata documentation for all available Docker images
across all nginx versions and operating system distributions. It scans the
nginx directory structure to find all available image combinations and
generates metadata for each one.
"""

import sys
import common
import os
import argparse
import subprocess

def main():
    parser = argparse.ArgumentParser(description="Generate metadata documentation for all nginx-lua Docker images")
    parser.add_argument(
        "os_distro",
        help="Operating system distribution (e.g., alpine, ubuntu, debian, fedora)"
    )
    args = parser.parse_args()

    os_distro = args.os_distro

    versions = common.load_supported_versions()

    nginx_versions = subprocess.getoutput("ls -1 ./nginx").splitlines()

    for nginx_version in nginx_versions:
        subfolder = "./nginx/%s/%s/" % (nginx_version, os_distro)
        if not os.path.isdir(subfolder):
            break

        distro_versions = subprocess.getoutput("ls -1 %s" % (subfolder)).splitlines()

        for distro_version in distro_versions:
            tag = "%s-%s%s" % (nginx_version, os_distro, distro_version)
            print(tag)

            common.generate_metadata(tag)

if __name__ == "__main__":
    main()