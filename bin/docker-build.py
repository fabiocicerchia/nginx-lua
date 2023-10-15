#!/usr/bin/env python3
import sys
import subprocess
import common

if __name__ == "__main__":
    os_distro = sys.argv[1]
    arch = sys.argv[2]

    # CircleCI workaround
    if arch == "x86_64":
        arch = "amd64"
    if arch == "aarch64":
        arch = "arm64v8"
    # / CircleCI workaround

    versions = common.get_all_versions()
    exit_code = common.build(
        versions["nginx"], os_distro, versions[os_distro], arch
    )

    if exit_code > 0:
        sys.exit(1)

    stdout = subprocess.getoutput("/usr/bin/docker images")
    print(stdout)
