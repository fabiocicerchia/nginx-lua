#!/usr/bin/env python3
import sys
import common
import os
import subprocess

if __name__ == "__main__":
    os_distro = sys.argv[1]
    versions = common.get_all_versions()

    nginx_versions = subprocess.getoutput("ls -1 ./nginx").splitlines()

    for nginx_version in nginx_versions:
        subfolder = "./nginx/%s/%s/" % (nginx_version, os_distro)
        if not os.path.isdir(subfolder):
            break

        distro_versions = subprocess.getoutput("ls -1 %s" % (subfolder)).splitlines()

        for distro_version in distro_versions:
            tag = "%s-%s%s" % (nginx_version, os_distro, distro_version)
            print(tag)

            common.metadata(tag)
