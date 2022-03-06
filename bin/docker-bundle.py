#!/usr/bin/env python3
import sys
import common

if __name__ == "__main__":
    os_distro = sys.argv[1]
    suffix = sys.argv[2] or ""

    versions = common.get_all_versions()
    exit_code = common.bundle(
        suffix, versions["nginx"], os_distro, versions[os_distro]
    )

    if exit_code > 0:
        sys.exit(1)
