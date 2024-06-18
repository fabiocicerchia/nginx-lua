#!/usr/bin/env python3
import operator
import re
import subprocess
import common

files = subprocess.getoutput(
    "find nginx -type f -name 'Dockerfile*' | sort -V",
).splitlines()

supported = common.get_supported_versions()

tags = {}
for file in files:
    pieces = re.search(r"nginx/(.+)/(.+)/(.+)/Dockerfile(-compat)?", file)

    nginx_ver, os_distro, osVer, compat = pieces.group(1, 2, 3, 4)
    nginx_ver_pieces = re.split(r"\.", nginx_ver)
    nginx_ver_major, nginx_ver_minor, nginx_ver_patch = nginx_ver_pieces
    suffix = ""
    if compat != None:
        suffix = "-compat"

    # tags[os_distro] = file # currently missing
    tags[
        nginx_ver_major
        + "."
        + nginx_ver_minor
        + "."
        + nginx_ver_patch
        + "-"
        + os_distro
        + osVer
        + suffix
    ] = file
    tags[
        nginx_ver_major
        + "."
        + nginx_ver_minor
        + "."
        + nginx_ver_patch
        + "-"
        + os_distro
        + suffix
    ] = file
    if os_distro == "alpine":
        tags[nginx_ver_major + "." + nginx_ver_minor + "-" + nginx_ver_patch + suffix] = file
    tags[nginx_ver_major + "." + nginx_ver_minor + "-" + os_distro + osVer + suffix] = file
    if not (os_distro == "amazonlinux" and osVer.startswith("2018")):
        tags[nginx_ver_major + "." + nginx_ver_minor + "-" + os_distro + suffix] = file
    if os_distro == "alpine":
        tags[nginx_ver_major + "." + nginx_ver_minor + suffix] = file
    tags[nginx_ver_major + "-" + os_distro + osVer + suffix] = file
    tags[os_distro + suffix] = file
    if not (os_distro == "amazonlinux" and osVer.startswith("2018")):
        tags[nginx_ver_major + "-" + os_distro + suffix] = file
    if os_distro == "alpine":
        tags[nginx_ver_major + suffix] = file
        tags["latest" + suffix] = file

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
    print(
        "- [`"
        + "`, `".join(dockerfiles[file])
        + "`](https://github.com/fabiocicerchia/nginx-lua/blob/main/"
        + file
        + ")"
    )

print("\n## Unsupported Tags\n")
reversed = list(reversed)[::-1]
for file in reversed:
    print(
        "- [`"
        + "`, `".join(dockerfiles[file])
        + "`](https://github.com/fabiocicerchia/nginx-lua/blob/main/"
        + file
        + ")"
    )
