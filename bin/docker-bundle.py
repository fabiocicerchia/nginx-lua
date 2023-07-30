#!/usr/bin/env python3
import sys
import common

if __name__ == "__main__":
    os_distro = sys.argv[1]

    versions = common.get_all_versions()
    exit_code = common.bundle(
        versions["nginx"], os_distro, versions[os_distro]
    )

    if exit_code > 0:
        sys.exit(1)
