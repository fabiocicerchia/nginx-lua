#!/bin/bash
# shellcheck disable=SC1091

source ./bin/_common.sh
source supported_versions

function test() {
    DOCKER_TAG=$1

    docker rm -f nginx_lua_test 2> /dev/null || true

    FOUND=$(docker image ls -q fabiocicerchia/nginx-lua:"$DOCKER_TAG" | wc -l)
    if [ "$FOUND" -ne "0" ]; then
        docker run -d --name nginx_lua_test -p 8080:80 -v "$PWD"/test/nginx-lua.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:"$DOCKER_TAG"
        COUNT=0
        until [ $COUNT -eq 20 ] || [ "$(curl --output /dev/null --silent --head --fail http://localhost:8080; echo $?)" == "0" ]; do
            echo -n '.'; sleep 0.5;
            COUNT=$((COUNT+1))
        done
        curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1
        curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1
        docker rm -f nginx_lua_test
     fi
}

function runtest() {
    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    test "$PATCH-$OS$OS_VER"
    test "$MINOR-$OS$OS_VER"
    test "$MAJOR-$OS$OS_VER"

    if [ "$LAST_VER_NGINX$LAST_VER_OS$DEFAULT_IMAGE" == "111" ]; then
        test "$MAJOR"
        test "$MINOR"
        test "$PATCH"
        test latest
    fi

    if [ "$LAST_VER_NGINX$LAST_VER_OS" == "11" ]; then
        test "$MAJOR-$OS"
        test "$MAJOR-$OS$OS_VER"
    fi

    if [ "$LAST_VER_OS" == "1" ]; then
        test "$MINOR-$OS"
        test "$PATCH-$OS"
    fi

}

set -eux

OS=$1
mapfile -t VERSIONS < <(get_versions "$OS")

docker images

loop_over_nginx_with_os "$OS" "runtest"