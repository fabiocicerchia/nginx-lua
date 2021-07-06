#!/bin/bash
# shellcheck disable=SC1091,SC2086,SC2207

source supported_versions

function docker_tag_exists() {
    curl --silent -f -lSL "https://index.docker.io/v1/repositories/$1/tags/$2" >/dev/null
    echo $?
}

function get_versions() {
    OS=$1
    VERSIONS=()
    if [ "$OS" == "alpine" ]; then
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

        # Default image is Alpine
        export DEFAULT_IMAGE=1
        export OS=alpine
        loop_over_os "$OS" "$FUNC"
        export DEFAULT_IMAGE=0

        export OS=amazonlinux
        loop_over_os "$OS" "$FUNC"

        export OS=centos
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
}
