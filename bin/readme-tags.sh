#!/bin/bash

source supported_versions

function tag() {
    NGINX_VER=$1
    OS=$2
    OS_VER=$3
    VER_TAGS=$4
    OS_TAGS=$5
    DEFAULT=$6

    DOCKERFILE_PATH=nginx/$NGINX_VER/$OS/$OS_VER
    DOCKERFILE=$DOCKERFILE_PATH/Dockerfile

    MAJOR=$(echo $NGINX_VER | cut -d '.' -f 1)
    MINOR=$MAJOR.$(echo $NGINX_VER | cut -d '.' -f 2)
    PATCH=$NGINX_VER
    
    STR=""

    if [ "$VER_TAGS$OS_TAGS$DEFAULT" == "111" ]; then
        STR="$STR \`$MAJOR\`"
        STR="$STR \`$MINOR\`"
        STR="$STR \`$PATCH\`"
    fi

    if [ "$VER_TAGS$OS_TAGS" == "11" ]; then
        STR="$STR \`$MAJOR-$OS\`"
        STR="$STR \`$MAJOR-$OS$OS_VER\`"
    fi

    if [ "$OS_TAGS" == "1" ]; then
        STR="$STR \`$MINOR-$OS\`"
        STR="$STR \`$PATCH-$OS\`"
    fi

    STR="$STR \`$PATCH-$OS$OS_VER\`"
    STR="$STR \`$MINOR-$OS$OS_VER\`"
    STR="$STR \`$MAJOR-$OS$OS_VER\`"

    STR=$(echo $STR | tr ' ' '\n' | awk '{ print length($0) " " $0; }' | sort -n | cut -d ' ' -f 2- | tr '\n', ',' | sed 's/.$//')    

    if [ "$VER_TAGS$OS_TAGS$DEFAULT" == "111" ]; then
        STR="$STR,\`latest\`"
    fi

    STR=" - [$STR](https://github.com/fabiocicerchia/nginx-lua/blob/master/$DOCKERFILE)"
    echo $STR
}

NLEN=${#NGINX[@]}
for (( I=0; I<$NLEN; I++ )); do
    NGINX_VER="${NGINX[$I]}"

    VER_TAGS=0
    if [ "$((I+1))" == "$NLEN" ]; then
        VER_TAGS=1
    fi

    # Default image is Alpine
    DEFAULT=1
    OS=alpine
    DLEN=${#ALPINE[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${ALPINE[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        tag $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    DEFAULT=0

    OS=amazonlinux
    DLEN=${#AMAZONLINUX[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${AMAZONLINUX[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        tag $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    OS=centos
    DLEN=${#CENTOS[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${CENTOS[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        tag $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    OS=debian
    DLEN=${#DEBIAN[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${DEBIAN[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        tag $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    OS=fedora
    DLEN=${#FEDORA[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${FEDORA[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        tag $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    OS=ubuntu
    DLEN=${#UBUNTU[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${UBUNTU[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        tag $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

done
