#!/usr/bin/env python3
"""
Generate Docker image tags documentation for nginx-lua.

This script analyses all Dockerfiles in the nginx directory and generates
comprehensive documentation of all available Docker image tags. It creates
a markdown-formatted list of tags organized by supported and unsupported versions.
"""

import operator
import re
from collections import defaultdict
from pathlib import Path
import common

# Constants
DOCKERFILE_PATTERN = "Dockerfile*"
DOCKERFILE_REGEX = r"nginx/(.+)/(.+)/(.+)/Dockerfile(-compat)?"
COMPAT_SUFFIX = "-compat"
ALPINE_DISTRO = "alpine"
AMAZONLINUX_DISTRO = "amazonlinux"
AMAZONLINUX_2018_PREFIX = "2018"
LATEST_TAG = "latest"
GITHUB_BASE_URL = "https://github.com/fabiocicerchia/nginx-lua/blob/main/"


def main():
    files = sorted(
        str(path) for path in Path("nginx").rglob(DOCKERFILE_PATTERN) if path.is_file()
    )

    supported = common.get_supported_versions()

    tags = {}
    for file in files:
        match = re.search(DOCKERFILE_REGEX, file)

        nginx_ver, os_distro, os_version, compat = match.group(1, 2, 3, 4)
        major, minor, patch = re.split(r"\.", nginx_ver)
        suffix = ""
        if compat is not None:
            suffix = COMPAT_SUFFIX

        is_alpine = os_distro == ALPINE_DISTRO
        # amazonlinux 2018 predates the unversioned distro tags and never claims them
        claims_distro_tag = not (
            os_distro == AMAZONLINUX_DISTRO
            and os_version.startswith(AMAZONLINUX_2018_PREFIX)
        )

        tags[f"{major}.{minor}.{patch}-{os_distro}{os_version}{suffix}"] = file
        tags[f"{major}.{minor}.{patch}-{os_distro}{suffix}"] = file
        if is_alpine:
            tags[f"{major}.{minor}.{patch}-{suffix}"] = file
        if is_alpine:
            tags[f"{major}.{minor}{suffix}"] = file
        tags[f"{major}-{os_distro}{os_version}{suffix}"] = file
        tags[f"{os_distro}{suffix}"] = file
        if claims_distro_tag:
            tags[f"{major}-{os_distro}{suffix}"] = file
        if is_alpine:
            tags[f"{major}{suffix}"] = file
            tags[f"{LATEST_TAG}{suffix}"] = file

    dockerfiles = defaultdict(list)
    unsupported = files
    for tag in tags:
        dockerfiles[tags[tag]].append(tag)
    for dockerfile in dockerfiles:
        dockerfiles[dockerfile] = sorted(
            dockerfiles[dockerfile], key=operator.itemgetter(0)
        )

    print("# Tags\n")
    print("## Supported Tags\n")
    for file in supported:
        unsupported.remove(file)
        print(f"- [`{', '.join(dockerfiles[file])}`]({GITHUB_BASE_URL}{file})")

    print("\n## Unsupported Tags\n")
    unsupported = list(unsupported)[::-1]
    for file in unsupported:
        print(f"- [`{', '.join(dockerfiles[file])}`]({GITHUB_BASE_URL}{file})")


if __name__ == "__main__":
    main()
