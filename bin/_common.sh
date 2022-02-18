#!/bin/bash
# shellcheck disable=SC1091,SC2086,SC2207

MAX_CPU=$(nproc)
PARALLEL_PROCS=$((MAX_CPU/2))

source supported_versions

# https://unix.stackexchange.com/questions/103920/parallelize-a-bash-for-loop
# initialize a semaphore with a given number of tokens
open_sem(){
    mkfifo pipe-$$
    exec 3<>pipe-$$
    rm pipe-$$
    local i=$1
    for((;i>0;i--)); do
        printf %s 000 >&3
    done
}

# run the given command asynchronously and pop/push tokens
run_with_lock(){
    local x
    # this read waits until there is something to read
    read -u 3 -n 3 x && ((0==x)) || exit $x
    (
     ( "$@"; )
    # push the return code of the command to the semaphore
    printf '%.3d' $? >&3
    )&
}

function docker_tag_exists() {
    curl --silent -f -lSL "https://index.docker.io/v1/repositories/$1/tags/$2" >/dev/null
    echo $?
}

function get_versions() {
    OS=$1
    VERSIONS=()
    if [ "$OS" == "almalinux" ]; then
        echo "${ALMALINUX[@]}"
    elif [ "$OS" == "alpine" ]; then
        echo "${ALPINE[@]}"
    elif [ "$OS" == "amazonlinux" ]; then
        echo "${AMAZONLINUX[@]}"
    elif [ "$OS" == "debian" ]; then
        echo "${DEBIAN[@]}"
    elif [ "$OS" == "fedora" ]; then
        echo "${FEDORA[@]}"
    elif [ "$OS" == "ubuntu" ]; then
        echo "${UBUNTU[@]}"
    fi
}

function loop_over_nginx_with_os() {
    OS=$1
    FUNC=$2

    LEN_VER_NGINX=${#NGINX[@]}
    for ((I = 0; I < LEN_VER_NGINX; I++)); do
        NGINX_VER="${NGINX[$I]}"

        LAST_VER_NGINX=0
        if [ "$((I + 1))" == "$LEN_VER_NGINX" ]; then
            LAST_VER_NGINX=1
        fi

        # Default image is Alpine
        DEFAULT_IMAGE=0
        if [ $OS == "alpine" ]; then
            DEFAULT_IMAGE=1
        fi

        loop_over_os "$OS" "$FUNC"

    done
}

function loop_over_nginx() {
    FUNC=$1

    LEN_VER_NGINX=${#NGINX[@]}
    for ((I = 0; I < LEN_VER_NGINX; I++)); do
        export NGINX_VER="${NGINX[$I]}"

        export LAST_VER_NGINX=0
        if [ "$((I + 1))" == "$LEN_VER_NGINX" ]; then
            export LAST_VER_NGINX=1
        fi

        export OS=almalinux
        loop_over_os "$OS" "$FUNC"

        # Default image is Alpine
        export DEFAULT_IMAGE=1
        export OS=alpine
        loop_over_os "$OS" "$FUNC"
        export DEFAULT_IMAGE=0

        export OS=amazonlinux
        loop_over_os "$OS" "$FUNC"

        export OS=debian
        loop_over_os "$OS" "$FUNC"

        export OS=fedora
        loop_over_os "$OS" "$FUNC"

        export OS=ubuntu
        loop_over_os "$OS" "$FUNC"

    done
}

function loop_over_os() {
    VERSIONS=($(get_versions "$OS"))
    FUNC=$2

    LEN_VER_OS=${#VERSIONS[@]}
    for ((J = 0; J < LEN_VER_OS; J++)); do
        export OS_VER="${VERSIONS[$J]}"

        export LAST_VER_OS=0
        if [ "$((J + 1))" == "$LEN_VER_OS" ]; then
            export LAST_VER_OS=1
        fi

        ${FUNC}
    done
    wait
}

# This is a very ugly way to make the AMD64 version of the images available in the host.
# When building a multi-arch image the images will not be loaded in the docker engine.
# In this way I'm taking advantage of some buildx cache to quickly recompile them and make
# it available for testing the amd64 version.
# NOTE: Except that it won't work due to BUILD_DATE being set to the second.
function preload_amd64_images() {
    source ./bin/_func_build.sh

    EXTENDED_IMAGE=YES
    MULTI_ARCH=0
    loop_over_nginx_with_os "$OS" "build_classic"
    loop_over_nginx_with_os "$OS" "build_compat"
}
