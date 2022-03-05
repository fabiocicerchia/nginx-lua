#!/usr/bin/env python3
import shutil
import common

if __name__ == "__main__":
    versions = common.get_all_versions()

    for os_distro in common.get_supported_os():
        common.init_dockerfile(versions["nginx"], os_distro, versions[os_distro])

    (exitcode, dockerfiles) = common.run_command("find nginx -type f -name 'Dockerfile'", False)
    dockerfiles = list(
        filter(
            lambda elem: elem.find("alpine") != -1,
            dockerfiles.split("\n")))
    dockerfiles.sort(reverse=True)
    shutil.copyfile(dockerfiles[0], "./Dockerfile")

    (exitcode, dockerfiles) = common.run_command("find nginx -type f -name 'Dockerfile-compat'", False)
    dockerfiles = list(
        filter(
            lambda elem: elem.find("alpine") != -1,
            dockerfiles.split("\n")))
    dockerfiles.sort(reverse=True)
    shutil.copyfile(dockerfiles[0], "./Dockerfile-compat")
