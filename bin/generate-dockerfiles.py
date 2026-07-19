#!/usr/bin/env python3
"""
Generate Dockerfiles for nginx-lua Docker images.

This script automates the creation of Dockerfiles for all supported nginx versions
and operating system distributions. It generates both mainline and stable nginx
versions for each supported OS distribution.
"""

import shutil
import common
import re
from pathlib import Path

def main():
    versions = common.load_supported_versions()

    for os_distro in common.get_supported_os():
        common.setup_dockerfile(versions["nginx_mainline"], os_distro, versions[os_distro])

    for os_distro in common.get_supported_os():
        common.setup_dockerfile(versions["nginx_stable"], os_distro, versions[os_distro])

    dockerfiles = [
        str(path) for path in Path("nginx").rglob("Dockerfile")
        if re.search(r"nginx/.+/alpine/\d+\.\d+\.\d+/", str(path))
    ]
    dockerfiles.sort(reverse=True)
    shutil.copyfile(dockerfiles[0], "./Dockerfile")

if __name__ == "__main__":
    main()