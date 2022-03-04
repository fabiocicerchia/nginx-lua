from datetime import datetime
import os
import re
import requests
import shlex
import shutil
import subprocess

supported_os = ["almalinux", "alpine", "amazonlinux", "debian", "fedora", "ubuntu"]
default_distro = "alpine"
image_repo = "fabiocicerchia/nginx-lua"

# UTILS
# ##############################################################################


def run_command(command, print_stdout):
    process = subprocess.Popen(
        shlex.split(command), shell=False, stdout=subprocess.PIPE
    )

    whole_output = []
    # Poll process.stdout to show stdout live
    while True:
        output = process.stdout.readline()
        whole_output.append(output.decode("ascii"))
        if process.poll() is not None:
            break
        if print_stdout and output:
            print(output.decode("ascii").strip())
    rc = process.poll()
    return [rc, "".join(whole_output)]


def read_file(file):
    content = ""
    with open(file, encoding="utf8") as f:
        for line in f:
            content += line
    return content


def write_file(file, content):
    with open(file, "w", encoding="utf-8") as f:
        f.write(content)


# MISC
# ##############################################################################


def docker_tag_exists(image, tag):
    url = "https://index.docker.io/v1/repositories/%s/tags/%s" % (image, tag)
    data = requests.get(url).json

    return data != []


def fetch_version_parts(version):
    major = version.split(".")[0]
    minor = major + "." + version.split(".")[1]
    patch = version

    return [major, minor, patch]


def get_tags(suffix, nginx_ver, os_distro, os_ver):
    tags = []

    (major, minor, patch) = fetch_version_parts(nginx_ver)

    # default image is alpine
    default_image = os_distro == default_distro

    if default_image:
        tags.append("%s%s" % (major, suffix))
        tags.append("%s%s" % (minor, suffix))
        tags.append("%s%s" % (patch, suffix))
        tags.append("latest%s" % (suffix))

    tags.append("%s%s" % (os_distro, suffix))
    tags.append("%s-%s%s" % (major, os_distro, suffix))
    tags.append("%s-%s%s%s" % (major, os_distro, os_ver, suffix))

    tags.append("%s-%s%s" % (minor, os_distro, suffix))
    tags.append("%s-%s%s" % (patch, os_distro, suffix))

    tags.append("%s-%s%s%s" % (patch, os_distro, os_ver, suffix))
    tags.append("%s-%s%s%s" % (minor, os_distro, os_ver, suffix))
    tags.append("%s-%s%s%s" % (major, os_distro, os_ver, suffix))

    tags = list(set(map(lambda x: image_repo + ":" + x, tags)))
    tags.sort(key=len)
    return tags


# BUILD
# ##############################################################################


def get_tarball_file(nginx_ver, os_distro, os_ver, suffix=""):
    dockerfile = get_dockerfile(nginx_ver, os_distro, os_ver, suffix)
    return get_tarball_file_from_dockerfile(dockerfile)


def get_tarball_file_from_dockerfile(dockerfile):
    tarball_file = (
        "dist/multiarch-" + re.sub('[^0-9a-zA-Z]+', '-', "%s" % (dockerfile)) + ".tar"
    )
    return tarball_file


def docker_build(vcs_ref, tags, dockerfile, arch, push=False):
    tags_param = " ".join(["-t %s" % (tag) for tag in tags])
    now = datetime.now()  # current date and time
    build_date = now.strftime("%Y-%m-%dT00:00:00Z")

    tarball_file = get_tarball_file_from_dockerfile(dockerfile)
    os.makedirs(os.path.dirname(tarball_file), exist_ok=True)

    push_flag = "--push" if push else ""
    output_tar = "--output type=tar,dest=%s" % (tarball_file) if not push else ""

    exit_code = run_command(
        """
        time docker buildx build
        --progress=plain
        --platform=linux/%s
        --build-arg BUILD_DATE="%s"
        --build-arg VCS_REF="%s"
        %s
        %s
        %s
        -f %s ."""
        % (arch, build_date, vcs_ref, output_tar, push_flag, tags_param, dockerfile),
        True
    )[0]

    return exit_code


def docker_rebuild_and_push(vcs_ref, tags, dockerfile):
    docker_build(vcs_ref, tags, dockerfile, "amd64", True)
    docker_build(vcs_ref, tags, dockerfile, "arm64/v8", True)


def build(suffix, nginx_ver, os_distro, os_ver, arch):

    dockerfile = get_dockerfile(nginx_ver, os_distro, os_ver, suffix)

    tags = get_tags(suffix, nginx_ver, os_distro, os_ver)

    vcs_ref = subprocess.getoutput("/usr/bin/git rev-parse --short HEAD").strip().decode("ascii")

    exit_code = docker_build(vcs_ref, tags, dockerfile, arch)
    return exit_code


# PUSH
# ##############################################################################


def docker_push(image_id, tag):
    cmd = "docker tag %s %s" % (image_id, tag)
    exitcode = run_command(cmd, True)[0]

    cmd = "docker push %s" % (tag)
    exitcode = run_command(cmd, True)[0]

    # retry
    if exitcode != 0:
        exitcode = run_command(cmd, True)[0]


def push_images(suffix, nginx_ver, os_distro, os_ver):
    tags = get_tags(suffix, nginx_ver, os_distro, os_ver)
    dockerfile = get_dockerfile(nginx_ver, os_distro, os_ver, suffix)
    vcs_ref = (
        subprocess.check_output(
            ['/usr/bin/git', 'rev-parse', '--short', 'HEAD'],
            shell=False
        )
        .strip()
        .decode("ascii")
    )
    docker_rebuild_and_push(vcs_ref, tags, dockerfile)


def push(nginx_ver, os_distro, os_ver):
    push_images("", nginx_ver, os_distro, os_ver)
    push_images("-compat", nginx_ver, os_distro, os_ver)


# METADATA
# ##############################################################################


def metadata(tag):
    cmd = "docker image ls -q %s:%s" % (image_repo, tag)
    img_exists = run_command(cmd, False)[1]
    if img_exists != "":
        content = "# %s:%s\n" % (image_repo, tag)
        content = content + "```json\n"
        cmd = "docker image inspect %s:%s" % (image_repo, tag)
        stdout = run_command(cmd, False)[1]
        content = content + stdout + "\n```"
        write_file("docs/metadata/%s.md" % (tag), content)


def get_all_versions():
    supported_versions = {}
    with open("supported_versions", encoding="utf8") as f:
        for line in f:
            os_distro, ver = line.strip().split("=")
            supported_versions[os_distro] = ver

    return supported_versions


def get_supported_os():
    return supported_os


def get_dockerfile(nginx_ver, os_distro, os_ver, suffix=""):
    return "nginx/%s/%s/%s/Dockerfile%s" % (nginx_ver, os_distro, os_ver, suffix)


def get_supported_versions():
    versions = get_all_versions()
    nginx_ver = versions["nginx"]

    supported_versions = []
    for os_distro in get_supported_os():
        supported_versions.append(
            get_dockerfile(nginx_ver, os_distro, versions[os_distro])
        )

    return supported_versions


# GENERATE DOCKERFILES
# ##############################################################################


def patch_dockerfile(dockerfile, nginx_ver, os_distro, os_ver):
    content = read_file(dockerfile)
    content = content.replace("{{DOCKER_IMAGE}}", image_repo)
    content = content.replace("{{DOCKER_IMAGE_OS}}", os_distro)
    content = content.replace("{{DOCKER_IMAGE_TAG}}", os_ver)
    content = content.replace("{{VER_NGINX}}", nginx_ver)

    write_file(dockerfile, content)


def init_dockerfile(nginx_ver, os_distro, os_ver):
    dockerfile = get_dockerfile(nginx_ver, os_distro, os_ver)

    os.makedirs(os.path.dirname(dockerfile), exist_ok=True)
    shutil.copyfile("tpl/Dockerfile.%s" % (os_distro), dockerfile)
    patch_dockerfile(dockerfile, nginx_ver, os_distro, os_ver)

    dockerfile = get_dockerfile(nginx_ver, os_distro, os_ver, "-compat")
    shutil.copyfile("tpl/Dockerfile.%s-compat" % (os_distro), dockerfile)
    patch_dockerfile(dockerfile, nginx_ver, os_distro, os_ver)


# TAGS
# ##############################################################################


def tag(nginx_ver, os_distro, os_ver):
    tags = get_tags("", nginx_ver, os_distro, os_ver)
    tags = "`, `".join(tags).replace(image_repo + ":", "")
    dockerfile = get_dockerfile(nginx_ver, os_distro, os_ver)

    print(
        "- [`%s`](https://github.com/fabiocicerchia/nginx-lua/blob/main/%s)"
        % (tags, dockerfile)
    )
