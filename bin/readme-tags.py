#!/usr/bin/env python3
import common

if __name__ == "__main__":
    versions = common.get_all_versions()

    for os_distro in common.get_supported_os():
        common.tag(versions["nginx"], os_distro, versions[os_distro], "")
        common.tag(versions["nginx"], os_distro, versions[os_distro], "-compat")
