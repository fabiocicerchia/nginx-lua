#!/usr/bin/env python3
import sys
import common

if __name__ == "__main__":
    os_distro = sys.argv[1]
    versions = common.get_all_versions()

    tag = "%s-%s%s" % (versions["nginx"], os_distro, versions[os_distro])
    common.metadata(tag)
