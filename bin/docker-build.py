#!/usr/bin/env python3
import sys
import subprocess
import common

if __name__ == "__main__":
    os_distro = sys.argv[1]
    suffix = sys.argv[2] or ""
    arch = sys.argv[3]

    if suffix != "":
        suffix = "-%s" % (suffix)

    # CircleCI workaround
    if arch == "medium":
        arch = "amd64"
    if arch == "arm.medium":
        arch = "arm64/v8"
    # / CircleCI workaround

    versions = common.get_all_versions()
    exit_code = common.build(
        suffix, versions["nginx"], os_distro, versions[os_distro], arch
    )

    if exit_code > 0:
        sys.exit(1)

    stdout = subprocess.check_output(["/usr/bin/docker", "images"])
    print(stdout)
