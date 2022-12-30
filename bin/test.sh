#!/bin/bash
# shellcheck disable=SC1091,SC2207

function handle_error() {
    docker logs nginx_lua_test
    exit 1
}

function test() {
    DOCKER_TAG=$1

    docker rm -f nginx_lua_test 2>/dev/null || true

    FOUND=$(docker image ls -q fabiocicerchia/nginx-lua:"$DOCKER_TAG" | wc -l)
    if [ "$FOUND" -ne "0" ]; then
        docker run -d --name nginx_lua_test -p 8080:80 -e SKIP_TRACK=1 -v "$PWD"/test/nginx-lua.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:"$DOCKER_TAG"

        if [[ "$DOCKER_TAG" == *"alpine"* ]]; then
            docker exec nginx_lua_test apk add gcc musl-dev coreutils wget || handle_error
        elif [[ "$DOCKER_TAG" == *"ubuntu"* ]] || [[ "$DOCKER_TAG" == *"debian"* ]]; then
            docker exec nginx_lua_test apt update || handle_error
            docker exec nginx_lua_test apt install -y gcc musl-dev coreutils wget || handle_error
        elif [[ "$DOCKER_TAG" == *"almalinux"* ]]; then
            docker exec nginx_lua_test yum install -y gcc wget || handle_error
        elif [[ "$DOCKER_TAG" == *"fedora"* ]] || [[ "$DOCKER_TAG" == *"amazon"* ]]; then
            docker exec nginx_lua_test yum install -y gcc musl-devel coreutils wget || handle_error
        fi
        # cannot run on almalinux (which uses 5.1) :
        # 	/usr/lib64/lua/5.3/cjson.so: undefined symbol: lua_rotate
        docker exec nginx_lua_test luarocks install lua-cjson || handle_error

        COUNT=0
        until [ $COUNT -eq 20 ] || [ "$(
            curl --output /dev/null --silent --head --fail http://localhost:8080
            echo $?
        )" == "0" ]; do
            echo -n '.'
            sleep 0.5
            COUNT=$((COUNT + 1))
        done

        curl -v http://localhost:8080 | grep "Welcome to nginx" || handle_error
        curl -v http://localhost:8080/lua_content | grep "Hello world" || handle_error
        docker exec nginx_lua_test curl -v --fail http://localhost:80/status | grep "Nginx Worker PID" || handle_error
        docker exec nginx_lua_test curl -v --fail http://localhost:80/metrics || handle_error
        curl -H'Connection: upgrade' -H'Upgrade: websocket' -H'Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==' -H'Sec-WebSocket-Version: 13' http://localhost:8080/socket | grep -a "Hello world" || handle_error
        curl -v --fail http://localhost:8080/shell | grep "ok" | grep -v "not ok" || handle_error
        curl -v --fail http://localhost:8080/dns | grep "www.google.com" || handle_error
        curl -v --fail --cookie 'lang=en' http://localhost:8080/cookie 2>&1 | grep "Set-Cookie: Name=Bob" || handle_error
        curl -v --fail http://localhost:8080/headers 2>&1 | grep "X-MyHeader: blah" || handle_error
        curl -v --fail http://localhost:8080/type 2>&1 | grep "Content-Type: text/plain" || handle_error

        # Only compat tags have LUA_COMPAT_5_1 enabled, if not using that flag, it triggers:
        # [error] 26#26: *177 lua entry thread aborted: runtime error: error loading module 'cjson' from file '/usr/local/lib/lua/5.4/cjson.so':
	    # /usr/local/lib/lua/5.4/cjson.so: undefined symbol: lua_newuserdatauv
        if [[ "$DOCKER_TAG" == *"compat"* ]]; then
            curl -v --fail http://localhost:8080/cjson || handle_error
        fi

        curl -v --fail http://localhost:8080/memcached || handle_error
        # TODO: missing https://github.com/openresty/lua-resty-string
        # curl -v --fail http://localhost:8080/mysql || handle_error
        curl -v --fail http://localhost:8080/redis || handle_error
        curl -v --fail http://localhost:8080/foo || handle_error
        curl -v --fail http://localhost:8080/bar-mysql || handle_error
        curl -v --fail http://localhost:8080/bar-pgsql || handle_error
        curl -v --fail http://localhost:8080/json || handle_error
        curl -v --fail http://localhost:8080/baz || handle_error
        curl -v --fail http://localhost:8080/foo-hash || handle_error
        curl -v --fail http://localhost:8080/base32 || handle_error
        curl -v --fail http://localhost:8080/base64 || handle_error
        curl -v --fail http://localhost:8080/hex || handle_error
        curl -v --fail http://localhost:8080/sha1 || handle_error
        curl -v --fail http://localhost:8080/sha1-2 || handle_error
        curl -v --fail http://localhost:8080/today || handle_error
        curl -v --fail http://localhost:8080/signature || handle_error
        curl -v --fail http://localhost:8080/rand || handle_error

        docker rm -f nginx_lua_test
    fi
}

set -eux

OS=$1
ARCH=$2

for DOCKERFILE in $(find nginx/*/"$OS" -name "Dockerfile*" -type f | sort); do
    TAG=$(echo "$DOCKERFILE" | sed 's_nginx/\(.*\)/\(.*\)/\(.*\)/Dockerfile\(-compat\)\?_\1-\2\3\4_')
    test "$TAG-$ARCH"
done
