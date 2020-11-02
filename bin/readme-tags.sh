#!/bin/bash
# shellcheck disable=SC1091

source ./bin/_common.sh
source supported_versions

function tag() {
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile"

    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"
    
    STR=""

    if [ "$LAST_VER_NGINX$LAST_VER_OS$DEFAULT_IMAGE" == "111" ]; then
        STR="$STR \`$MAJOR\`"
        STR="$STR \`$MINOR\`"
        STR="$STR \`$PATCH\`"
    fi

    if [ "$LAST_VER_NGINX$LAST_VER_OS" == "11" ]; then
        STR="$STR \`$OS\`"
        STR="$STR \`$MAJOR-$OS\`"
        STR="$STR \`$MAJOR-$OS$OS_VER\`"
    fi

    if [ "$LAST_VER_OS" == "1" ]; then
        STR="$STR \`$MINOR-$OS\`"
        STR="$STR \`$PATCH-$OS\`"
    fi

    STR="$STR \`$PATCH-$OS$OS_VER\`"
    STR="$STR \`$MINOR-$OS$OS_VER\`"
    STR="$STR \`$MAJOR-$OS$OS_VER\`"

    STR=$(echo "$STR" | xargs | tr ' ' '\n' | awk '{ print length($0) " " $0; }' | sort -n | cut -d ' ' -f 2- | tr '\n', ',' | sed 's/.$//')

    if [ "$LAST_VER_NGINX$LAST_VER_OS$DEFAULT_IMAGE" == "111" ]; then
        STR="$STR,\`latest\`"
    fi

    STR="- [$STR](https://github.com/fabiocicerchia/nginx-lua/blob/master/$DOCKERFILE)"
    echo "$STR"
}

loop_over_nginx "tag"