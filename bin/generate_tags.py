#!/usr/bin/env python3
import operator
import re
import subprocess
import common

# TODO: ADD SUPPORT FOR -compat
files = subprocess.getoutput(
    "find nginx -type f | sort -V | grep -v compat"
).splitlines()

supported = common.get_supported_versions()

tags = {}
for file in files:
    pieces = re.search("nginx/(.+)/(.+)/(.+)/Dockerfile", file)

    nginx_ver, os_distro, osVer = pieces.group(1, 2, 3)
    nginx_ver_pieces = re.split(r"\.", nginx_ver)
    nginx_ver_major, nginx_ver_minor, nginx_ver_patch = nginx_ver_pieces

    # tags[os_distro] = file # currently missing
    tags[nginx_ver_major + "." + nginx_ver_minor + "." +
         nginx_ver_patch + "-" + os_distro + osVer] = file
    tags[nginx_ver_major + "." + nginx_ver_minor +
         "." + nginx_ver_patch + "-" + os_distro] = file
    if os_distro == "alpine":
        tags[nginx_ver_major + "." + nginx_ver_minor + "-" + nginx_ver_patch] = file
    tags[nginx_ver_major + "." + nginx_ver_minor + "-" + os_distro + osVer] = file
    if not (os_distro == "amazonlinux" and osVer.startswith("2018")):
        tags[nginx_ver_major + "." + nginx_ver_minor + "-" + os_distro] = file
    if os_distro == "alpine":
        tags[nginx_ver_major + "." + nginx_ver_minor] = file
    tags[nginx_ver_major + "-" + os_distro + osVer] = file
    tags[os_distro] = file
    if not (os_distro == "amazonlinux" and osVer.startswith("2018")):
        tags[nginx_ver_major + "-" + os_distro] = file
    if os_distro == "alpine":
        tags[nginx_ver_major] = file
        tags["latest"] = file

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
