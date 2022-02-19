#!/usr/bin/env python3
import sys
import common

if __name__ == "__main__":
    os_distro = sys.argv[1]

    versions = common.get_all_versions()
    for os_distro in common.get_supported_os():
        common.push(versions["nginx"], os_distro, versions[os_distro])
        common.push_compat(versions["nginx"], os_distro, versions[os_distro])
