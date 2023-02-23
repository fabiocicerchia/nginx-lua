#!/usr/bin/env python3

import common
import sys

if __name__ == "__main__":
    os_distro = sys.argv[1]
    versions = common.get_all_versions()

    tag = "%s-%s%s" % (versions["nginx"], os_distro, versions[os_distro])
    exit_code = common.metadata(tag)

    if exit_code > 0:
        sys.exit(1)
