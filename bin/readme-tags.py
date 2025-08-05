#!/usr/bin/env python3
"""
Generate README tags documentation for nginx-lua.

This script generates markdown-formatted tag documentation for the README file.
It creates a list of all available Docker image tags for the supported nginx
versions and operating system distributions.
"""

import common

def main():
    versions = common.load_supported_versions()

    for os_distro in common.get_supported_os():
        common.print_tags(versions["nginx_mainline"], os_distro, versions[os_distro])
        # common.print_tags(versions["nginx_stable"], os_distro, versions[os_distro])

if __name__ == "__main__":
    main()