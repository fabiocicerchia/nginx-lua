#!/bin/bash
# shellcheck disable=SC2207,SC2129

if [ ! -d /tmp/generate-supported-versions ]; then
    mkdir -p /tmp/generate-supported-versions
fi

fetch_mainline() {
    fetch_specific $1 $2 "mainline"
}

fetch_stable() {
    fetch_specific $1 $2 "stable"
}

fetch_latest() {
    fetch_specific $1 $2 "latest"
}

fetch_specific() {
    DISTRO=$1
    FILTER=${2-}
    if [ "$FILTER" == "" ]; then
        FILTER=".+"
    fi
    SPECIFIC_TAG=$3

    TAG=$(curl -s "https://raw.githubusercontent.com/docker-library/official-images/master/library/$DISTRO" | grep $SPECIFIC_TAG | cut -d: -f2 | tr ',' '\n' | xargs -n1 | grep -E "$FILTER" | sort -VR | head -n1)
    if [ $TAG != "" ]; then
        echo $TAG;
        return;
    fi

    DIGEST=$(skopeo inspect --override-arch amd64 docker://$DISTRO:$SPECIFIC_TAG | jq -r '.Digest')
    TAGS=$(skopeo list-tags --override-arch amd64 docker://$DISTRO | jq -r '.Tags[]' | grep -E "$FILTER" | sort -Vr)

    for TAG in $TAGS; do
        VER=$(skopeo inspect --override-arch amd64 docker://$DISTRO:$TAG | jq -rc 'select( .Digest == "'"$DIGEST"'")')
        if [ "$VER" != "" ]; then
            echo "$TAG";
            return;
        fi
    done
}

set -eux

# nginx stable vs mainline
# Ref: https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
#
# Mainline version
# Mainline version (also Mainline release, Mainline branch) is the latest development version, updated approximately
# every 1 or 2 months, includes the latest features, bug fixes and security fixes. This version is recommended for
# production unless your organization has strict requirements for stability, in which case the stable version might be
# the better choice. The Mainline version always has an odd middle number, for example, 1.27.X.
#
# Stable version
# Stable version (also Stable release, Stable branch) is updated typically once a year or as needed for critical bug
# fixes or security fixes that are always backported from the Mainline version. This version is recommended for
# environments with strict requirements for stability. The Stable version is always even-numbered, for example, 1.28.X.
#
# `latest` for nginx is the `mainline`.
VER_NGINX_MAINLINE=$(fetch_mainline "nginx" "^[0-9]\.[0-9]{1,2}\.[0-9]{1,2}$")
if [ "$VER_NGINX_MAINLINE" = "" ]; then
    echo "Wrong version count in NGINX (mainline)."
    exit 1
fi
VER_NGINX_STABLE=$(fetch_stable "nginx" "^[0-9]\.[0-9]{1,2}\.[0-9]{1,2}$")
if [ "$VER_NGINX_STABLE" = "" ]; then
    echo "Wrong version count in NGINX (stable)."
    exit 1
fi

VER_ALMALINUX=$(fetch_latest "almalinux" "^[0-9]\.[0-9]{1,2}-[0-9]{8}$")
if [ "$VER_ALMALINUX" = "" ]; then
    echo "Wrong version count in ALMALINUX."
    exit 1
fi

VER_ALPINE=$(fetch_latest "alpine" "^[0-9]\.[0-9]{1,2}\.[0-9]{1,2}$")
if [ "$VER_ALPINE" = "" ]; then
    echo "Wrong version count in ALPINE."
    exit 1
fi

VER_AMAZONLINUX=$(fetch_latest "amazonlinux" "^202[3-9]\.[0-9]{1,2}\.[0-9]{8}(\.[0-9])?$")
if [ "$VER_AMAZONLINUX" = "" ]; then
    echo "Wrong version count in AMAZONLINUX."
    exit 1
fi

VER_DEBIAN=$(fetch_latest "debian" "^[0-9]{2}\.[0-9]{1,2}")
if [ "$VER_DEBIAN" = "" ]; then
    echo "Wrong version count in DEBIAN."
    exit 1
fi

VER_FEDORA=$(fetch_latest "fedora" "^[0-9]{2}$")
if [ "$VER_FEDORA" = "" ]; then
    echo "Wrong version count in FEDORA."
    exit 1
fi

VER_UBUNTU=$(fetch_latest "ubuntu" "^[0-9]{2}\.[0-9]{2}")
if [ "$VER_UBUNTU" = "" ]; then
    echo "Wrong version count in UBUNTU."
    exit 1
fi

cp supported_versions supported_versions.bak

echo "nginx_mainline=${VER_NGINX_MAINLINE}" >supported_versions
echo "nginx_stable=${VER_NGINX_STABLE}" >supported_versions
echo "almalinux=${VER_ALMALINUX}" >>supported_versions
echo "alpine=${VER_ALPINE}" >>supported_versions
echo "amazonlinux=${VER_AMAZONLINUX}" >>supported_versions
echo "debian=${VER_DEBIAN}" >>supported_versions
echo "fedora=${VER_FEDORA}" >>supported_versions
echo "ubuntu=${VER_UBUNTU}" >>supported_versions

DIFF=$(diff supported_versions supported_versions.bak | wc -l | tr -d ' ')
rm supported_versions.bak
echo "$DIFF"
