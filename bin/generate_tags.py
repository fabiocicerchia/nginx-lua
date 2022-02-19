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

    nginxVer, os_distro, osVer = pieces.group(1, 2, 3)
    nginxVerPieces = re.split(r"\.", nginxVer)
    nginxVerMajor, nginxVerMinor, nginxVerPatch = nginxVerPieces

    # tags[os_distro] = file # currently missing
    tags[nginxVerMajor + "." + nginxVerMinor + "." +
         nginxVerPatch + "-" + os_distro + osVer] = file
    tags[nginxVerMajor + "." + nginxVerMinor +
         "." + nginxVerPatch + "-" + os_distro] = file
    if os_distro == "alpine":
        tags[nginxVerMajor + "." + nginxVerMinor + "-" + nginxVerPatch] = file
    tags[nginxVerMajor + "." + nginxVerMinor + "-" + os_distro + osVer] = file
    if not (os_distro == "amazonlinux" and osVer.startswith("2018")):
        tags[nginxVerMajor + "." + nginxVerMinor + "-" + os_distro] = file
    if os_distro == "alpine":
        tags[nginxVerMajor + "." + nginxVerMinor] = file
    tags[nginxVerMajor + "-" + os_distro + osVer] = file
    tags[os_distro] = file
    if not (os_distro == "amazonlinux" and osVer.startswith("2018")):
        tags[nginxVerMajor + "-" + os_distro] = file
    if os_distro == "alpine":
        tags[nginxVerMajor] = file
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
