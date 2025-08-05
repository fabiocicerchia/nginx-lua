#!/usr/bin/env python3
"""
Generate Docker image tags documentation for nginx-lua.

This script analyses all Dockerfiles in the nginx directory and generates
comprehensive documentation of all available Docker image tags. It creates
a markdown-formatted list of tags organized by supported and unsupported versions.
"""

import operator
import re
import subprocess
import common

# Constants
DOCKERFILE_PATTERN = "Dockerfile*"
FIND_COMMAND = f"find nginx -type f -name '{DOCKERFILE_PATTERN}' | sort -V"
DOCKERFILE_REGEX = r"nginx/(.+)/(.+)/(.+)/Dockerfile(-compat)?"
COMPAT_SUFFIX = "-compat"
ALPINE_DISTRO = "alpine"
AMAZONLINUX_DISTRO = "amazonlinux"
AMAZONLINUX_2018_PREFIX = "2018"
LATEST_TAG = "latest"
GITHUB_BASE_URL = "https://github.com/fabiocicerchia/nginx-lua/blob/main/"

def main():
    files = subprocess.getoutput(FIND_COMMAND).splitlines()

    supported = common.get_supported_versions()

    tags = {}
    for file in files:
        pieces = re.search(DOCKERFILE_REGEX, file)

        nginx_ver, os_distro, osVer, compat = pieces.group(1, 2, 3, 4)
        nginx_ver_pieces = re.split(r"\.", nginx_ver)
        nginx_ver_major, nginx_ver_minor, nginx_ver_patch = nginx_ver_pieces
        suffix = ""
        if compat != None:
            suffix = COMPAT_SUFFIX

        # tags[os_distro] = file # currently missing
        tags[f"{nginx_ver_major}.{nginx_ver_minor}.{nginx_ver_patch}-{os_distro}{osVer}{suffix}"] = file
        tags[f"{nginx_ver_major}.{nginx_ver_minor}.{nginx_ver_patch}-{os_distro}{suffix}"] = file
        if os_distro == ALPINE_DISTRO:
            tags[f"{nginx_ver_major}.{nginx_ver_minor}.{nginx_ver_patch}-{suffix}"] = file
        tags[f"{nginx_ver_major}.{nginx_ver_minor}.{nginx_ver_patch}-{os_distro}{osVer}{suffix}"] = file
        if not (os_distro == AMAZONLINUX_DISTRO and osVer.startswith(AMAZONLINUX_2018_PREFIX)):
            tags[f"{nginx_ver_major}.{nginx_ver_minor}.{nginx_ver_patch}-{os_distro}{suffix}"] = file
        if os_distro == ALPINE_DISTRO:
            tags[f"{nginx_ver_major}.{nginx_ver_minor}{suffix}"] = file
        tags[f"{nginx_ver_major}-{os_distro}{osVer}{suffix}"] = file
        tags[f"{os_distro}{suffix}"] = file
        if not (os_distro == AMAZONLINUX_DISTRO and osVer.startswith(AMAZONLINUX_2018_PREFIX)):
            tags[f"{nginx_ver_major}-{os_distro}{suffix}"] = file
        if os_distro == ALPINE_DISTRO:
            tags[f"{nginx_ver_major}{suffix}"] = file
            tags[f"{LATEST_TAG}{suffix}"] = file

    dockerfiles = {}
    reversed = files
    for tag in tags:
        dockerfile = tags[tag]
        if dockerfile not in dockerfiles:
            dockerfiles[dockerfile] = []
        dockerfiles[dockerfile].append(tag)
        dockerfiles[dockerfile] = sorted(
            dockerfiles[dockerfile], key=operator.itemgetter(0)
        )

    print("# Tags\n")
    print("## Supported Tags\n")
    for file in supported:
        reversed.remove(file)
        print(f"- [`{', '.join(dockerfiles[file])}`]({GITHUB_BASE_URL}{file})")

    print("\n## Unsupported Tags\n")
    reversed = list(reversed)[::-1]
    for file in reversed:
        print(f"- [`{', '.join(dockerfiles[file])}`]({GITHUB_BASE_URL}{file})")

if __name__ == "__main__":
    main()