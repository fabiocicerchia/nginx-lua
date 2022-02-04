#!/bin/bash
# shellcheck disable=SC1091,SC2207

source ./bin/_common.sh
source supported_versions

function test() {
    DOCKER_TAG=$1

    docker rm -f nginx_lua_test 2>/dev/null || true

    FOUND=$(docker image ls -q fabiocicerchia/nginx-lua:"$DOCKER_TAG" | wc -l)
    if [ "$FOUND" -ne "0" ]; then
        docker run -d --name nginx_lua_test -p 8080:80 -e SKIP_TRACK=1 -v "$PWD"/test/nginx-lua.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:"$DOCKER_TAG"

        # TODO: THIS WORKS ONLY FOR ALPINE!!
        if [[ "$DOCKER_TAG" == *"alpine"* ]]; then
            docker exec nginx_lua_test apk add gcc musl-dev coreutils
            docker exec nginx_lua_test luarocks install lua-cjson
        fi

        COUNT=0
        until [ $COUNT -eq 20 ] || [ "$(
            curl --output /dev/null --silent --head --fail http://localhost:8080
            echo $?
        )" == "0" ]; do
            echo -n '.'
            sleep 0.5
            COUNT=$((COUNT + 1))
        done

        curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1
        curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1
        docker exec nginx_lua_test curl -v --fail http://localhost:80/status | grep "Nginx Worker PID" || exit 1
        curl -H'Connection: upgrade' -H'Upgrade: websocket' -H'Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==' -H'Sec-WebSocket-Version: 13' http://localhost:8080/socket | grep -a "Hello world" || exit 1
        curl -v --fail http://localhost:8080/shell | grep "ok" | grep -v "not ok" || exit 1
        curl -v --fail http://localhost:8080/dns | grep "www.google.com" || exit 1
        curl -v --fail --cookie 'lang=en' http://localhost:8080/cookie 2>&1 | grep "Set-Cookie: Name=Bob" || exit 1
        curl -v --fail http://localhost:8080/bar 2>&1 | grep "X-MyHeader: blah" || exit 1
        curl -v --fail http://localhost:8080/type 2>&1 | grep "Content-Type: text/plain" || exit 1

        if [[ "$DOCKER_TAG" == *"-compat" ]]; then
            if [[ "$DOCKER_TAG" == *"alpine"* ]]; then
                curl -v --fail http://localhost:8080/cjson || exit 1
            fi
        fi

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
VERSIONS=($(get_versions "$OS"))

docker images

loop_over_nginx_with_os "$OS" "runtest"
