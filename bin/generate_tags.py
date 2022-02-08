#!/usr/bin/env python3
import operator
import re
import subprocess

# TODO: ADD SUPPORT FOR -compat
files = subprocess.getoutput(
    "find nginx -type f | sort -V | grep -v compat"
).splitlines()

result = subprocess.run(["./bin/docker-supported.sh"], stdout=subprocess.PIPE)
supported = result.stdout.decode("utf-8").splitlines()

tags = {}
for file in files:
    pieces = re.search("nginx/(.+)/(.+)/(.+)/Dockerfile", file)

    nginxVer, os, osVer = pieces.group(1, 2, 3)
    nginxVerPieces = re.split(r"\.", nginxVer)
    nginxVerMajor, nginxVerMinor, nginxVerPatch = nginxVerPieces

    # tags[os] = file # currently missing
    tags[
        nginxVerMajor + "." + nginxVerMinor + "." + nginxVerPatch + "-" + os + osVer
    ] = file
    tags[nginxVerMajor + "." + nginxVerMinor + "." + nginxVerPatch + "-" + os] = file
    if os == "alpine":
        tags[nginxVerMajor + "." + nginxVerMinor + "-" + nginxVerPatch] = file
    tags[nginxVerMajor + "." + nginxVerMinor + "-" + os + osVer] = file
    if not (os == "amazonlinux" and osVer.startswith("2018")):
        tags[nginxVerMajor + "." + nginxVerMinor + "-" + os] = file
    if os == "alpine":
        tags[nginxVerMajor + "." + nginxVerMinor] = file
    tags[nginxVerMajor + "-" + os + osVer] = file
    tags[os] = file
    if not (os == "amazonlinux" and osVer.startswith("2018")):
        tags[nginxVerMajor + "-" + os] = file
    if os == "alpine":
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
