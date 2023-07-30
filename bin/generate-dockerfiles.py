#!/usr/bin/env python3
import shutil
import common
import subprocess
import re

if __name__ == "__main__":
    versions = common.get_all_versions()

    for os_distro in common.get_supported_os():
        common.init_dockerfile(versions["nginx"], os_distro, versions[os_distro])

    dockerfiles = subprocess.check_output(['find', 'nginx', '-type', 'f', '-name', 'Dockerfile'])
    dockerfiles = list(
        filter(
            lambda elem: re.search("nginx/.+/alpine/\d+\.\d+\.\d+/", elem),
            dockerfiles.decode("utf-8").split("\n")))
    dockerfiles.sort(reverse=True)
    shutil.copyfile(dockerfiles[0], "./Dockerfile")
