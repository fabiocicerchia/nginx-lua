#!/usr/bin/env python3
import sys
import subprocess
import common

if __name__ == "__main__":
    os_distro = sys.argv[1]
    extended_image = (sys.argv[2] or "YES") == "YES"
    multi_arch = (sys.argv[3] or "YES") == "YES"

    versions = common.get_all_versions()
    for os_distro in common.get_supported_os():
        common.build_all(versions["nginx"], os_distro, versions[os_distro], extended_image, multi_arch)

    stdout = subprocess.check_output(['docker', 'images'])
    print(stdout)
