#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2023 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

ARG ARCH=
ARG DISTRO=alpine
ARG DISTRO_VER=3.17.3

#############################
# Settings Common Variables #
#############################
FROM ${ARCH}/$DISTRO:$DISTRO_VER AS base

ARG ARCH=
ENV ARCH=$ARCH

ENV DOCKER_IMAGE=fabiocicerchia/nginx-lua
ENV DOCKER_IMAGE_OS=${DISTRO}
ENV DOCKER_IMAGE_TAG=${DISTRO_VER}

ARG BUILD_DATE
ENV BUILD_DATE=$BUILD_DATE
ARG VCS_REF
ENV VCS_REF=$VCS_REF

# lua
# https://www.lua.org/versions.html
ARG VER_LUA=5.4
ENV VER_LUA=$VER_LUA

# ngx_devel_kit
# https://github.com/vision5/ngx_devel_kit
# The NDK is now considered to be stable.
ARG VER_NGX_DEVEL_KIT=0.3.2
ENV VER_NGX_DEVEL_KIT=$VER_NGX_DEVEL_KIT

# luajit2
# https://github.com/openresty/luajit2
# Note: LuaJIT2 is stuck on Lua 5.1 since 2009.
ARG VER_LUAJIT=2.1-20230119
ENV VER_LUAJIT=$VER_LUAJIT
ARG LUAJIT_LIB=/usr/local/lib
ENV LUAJIT_LIB=$LUAJIT_LIB
ARG LUAJIT_INC=/usr/local/include/luajit-2.1
ENV LUAJIT_INC=$LUAJIT_INC
ARG LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# lua-nginx-module
# https://github.com/openresty/lua-nginx-module
# Production ready.
ARG VER_LUA_NGINX_MODULE=0.10.23
ENV VER_LUA_NGINX_MODULE=$VER_LUA_NGINX_MODULE

# lua-resty-core
# https://github.com/openresty/lua-resty-core
# This library is production ready.
ARG VER_LUA_RESTY_CORE=0.1.25
ENV VER_LUA_RESTY_CORE=$VER_LUA_RESTY_CORE
ARG LUA_LIB_DIR=/usr/local/share/lua/5.4
ENV LUA_LIB_DIR=$LUA_LIB_DIR

# lua-resty-lrucache
# https://github.com/openresty/lua-resty-lrucache
# This library is considered production ready.
ARG VER_LUA_RESTY_LRUCACHE=0.13
ENV VER_LUA_RESTY_LRUCACHE=$VER_LUA_RESTY_LRUCACHE

# headers-more-nginx-module
# https://github.com/openresty/headers-more-nginx-module
ARG VER_OPENRESTY_HEADERS=0.34
ENV VER_OPENRESTY_HEADERS=$VER_OPENRESTY_HEADERS

# lua-resty-cookie
# https://github.com/cloudflare/lua-resty-cookie
ARG VER_CLOUDFLARE_COOKIE=99be1005e38ce19ace54515272a2be1b9fdc5da2
ENV VER_CLOUDFLARE_COOKIE=$VER_CLOUDFLARE_COOKIE

# lua-resty-dns
# https://github.com/openresty/lua-resty-dns
ARG VER_OPENRESTY_DNS=0.22
ENV VER_OPENRESTY_DNS=$VER_OPENRESTY_DNS

# lua-resty-memcached
# https://github.com/openresty/lua-resty-memcached
ARG VER_OPENRESTY_MEMCACHED=0.17
ENV VER_OPENRESTY_MEMCACHED=$VER_OPENRESTY_MEMCACHED

# lua-resty-mysql
# https://github.com/openresty/lua-resty-mysql
ARG VER_OPENRESTY_MYSQL=0.26
ENV VER_OPENRESTY_MYSQL=$VER_OPENRESTY_MYSQL

# lua-resty-redis
# https://github.com/openresty/lua-resty-redis
ARG VER_OPENRESTY_REDIS=0.30
ENV VER_OPENRESTY_REDIS=$VER_OPENRESTY_REDIS

# lua-resty-shell
# https://github.com/openresty/lua-resty-shell
ARG VER_OPENRESTY_SHELL=0.03
ENV VER_OPENRESTY_SHELL=$VER_OPENRESTY_SHELL

# lua-resty-signal
# https://github.com/openresty/lua-resty-signal
ARG VER_OPENRESTY_SIGNAL=0.03
ENV VER_OPENRESTY_SIGNAL=$VER_OPENRESTY_SIGNAL

# lua-tablepool
# https://github.com/openresty/lua-tablepool
ARG VER_OPENRESTY_TABLEPOOL=0.02
ENV VER_OPENRESTY_TABLEPOOL=$VER_OPENRESTY_TABLEPOOL

# lua-resty-upstream-healthcheck
# https://github.com/openresty/lua-resty-upstream-healthcheck
ARG VER_OPENRESTY_HEALTHCHECK=f0b6528fe08415e900d95e78133d2612860957b2
ENV VER_OPENRESTY_HEALTHCHECK=$VER_OPENRESTY_HEALTHCHECK

# lua-resty-websocket
# https://github.com/openresty/lua-resty-websocket
ARG VER_OPENRESTY_WEBSOCKET=0.10
ENV VER_OPENRESTY_WEBSOCKET=$VER_OPENRESTY_WEBSOCKET

# lua-rocks
# https://luarocks.github.io/luarocks/releases/
ARG VER_LUAROCKS=3.9.2
ENV VER_LUAROCKS=$VER_LUAROCKS

# lua-upstream-nginx-module
# https://github.com/openresty/lua-upstream-nginx-module
ARG VER_LUA_UPSTREAM=0.07
ENV VER_LUA_UPSTREAM=$VER_LUA_UPSTREAM

# nginx-lua-prometheus
# https://github.com/knyar/nginx-lua-prometheus
ARG VER_PROMETHEUS=0.20221218
ENV VER_PROMETHEUS=$VER_PROMETHEUS

# set-misc-nginx-module
# https://github.com/openresty/set-misc-nginx-module
ARG VER_MISC_NGINX=0.33
ENV VER_MISC_NGINX=$VER_MISC_NGINX

# stream-lua-nginx-module
# https://github.com/openresty/stream-lua-nginx-module
ARG VER_OPENRESTY_STREAMLUA=0.0.12
ENV VER_OPENRESTY_STREAMLUA=$VER_OPENRESTY_STREAMLUA

# https://github.com/nginx/nginx/releases
ARG VER_NGINX=1.23.4
ENV VER_NGINX=$VER_NGINX

# https://github.com/nginx/njs
ARG VER_NJS=0.7.10
ENV VER_NJS=$VER_NJS

# Replicate same official env variable
ENV NGINX_VERSION   $VER_NGINX
ENV NJS_VERSION     $VER_NJS
ENV PKG_RELEASE     1~$DISTRO_VER

# References:
#  - https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc
#  - https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
# -g                        Generate debugging information
# -O2                       Recommended optimizations
# -fstack-protector-strong  Stack smashing protector
# -Wformat                  Check calls to make sure that the arguments supplied have types appropriate to the format string specified
# -Werror=format-security   Reject potentially unsafe format string arguents
# -Wp,-D_FORTIFY_SOURCE=2   Run-time buffer overflow detection
# -fPIC                     No text relocations
# ORIGINAL VALUE: -g -O2 -ffile-prefix-map=/data/builder/debuild/nginx-1.23.3/debian/debuild-base/nginx-1.23.3=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC
ARG NGX_CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC"
ENV NGX_CFLAGS=$NGX_CFLAGS
# References
#  - https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc
#  - https://wiki.debian.org/ToolChain/DSOLinking#Unresolved_symbols_in_shared_libraries
#  - https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_node/ld_3.html
#  - https://linux.die.net/man/1/ld
# -Wl,-rpath,/usr/local/lib   Add a directory to the runtime library search path
# -Wl,-z,relro                Read-only segments after relocation
# -Wl,-z,now                  Disable lazy binding
# -Wl,--as-needed             Only link with needed libraries
# -pie                        Full ASLR for executables
# ORIGINAL VALUE: -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie
ARG NGX_LDOPT="-Wl,-rpath,/usr/local/lib -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie"
ENV NGX_LDOPT=$NGX_LDOPT
# Reference: http://nginx.org/en/docs/configure.html
ARG NGINX_BUILD_CONFIG="\
            --prefix=/etc/nginx \
            --sbin-path=/usr/sbin/nginx \
            --modules-path=/usr/lib/nginx/modules \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-perl_modules_path=/usr/lib/perl5/vendor_perl \
            --user=nginx \
            --group=nginx \
            --with-compat \
            --with-file-aio \
            --with-threads \
            --with-http_addition_module \
            --with-http_auth_request_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_mp4_module \
            --with-http_random_index_module \
            --with-http_realip_module \
            --with-http_secure_link_module \
            --with-http_slice_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-mail \
            --with-mail_ssl_module \
            --with-stream \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module \
            --add-module=/njs-${VER_NJS}/nginx \
            --add-module=/lua-nginx-module-${VER_LUA_NGINX_MODULE} \
            --add-module=/ngx_devel_kit-${VER_NGX_DEVEL_KIT} \
            --add-module=/lua-upstream-nginx-module-${VER_LUA_UPSTREAM} \
            --add-module=/headers-more-nginx-module-${VER_OPENRESTY_HEADERS} \
            --add-module=/stream-lua-nginx-module-${VER_OPENRESTY_STREAMLUA} \
            --add-module=/set-misc-nginx-module-${VER_MISC_NGINX} \
"
ENV NGINX_BUILD_CONFIG=$NGINX_BUILD_CONFIG

ARG BUILD_DEPS_BASE="\
        curl \
        geoip-dev \
        gzip \
        lua${VER_LUA} \
        lua${VER_LUA}-dev \
        make \
        openssl-dev \
        patch \
        pcre-dev \
        tar \
        zlib-dev \
"
ENV BUILD_DEPS_BASE=$BUILD_DEPS_BASE
ARG BUILD_DEPS_AMD64="\
        ${BUILD_DEPS_BASE} \
        g++ \
"
ENV BUILD_DEPS_AMD64=$BUILD_DEPS_AMD64
ARG BUILD_DEPS_ARM64V8="\
        ${BUILD_DEPS_BASE} \
        gcc-aarch64-none-elf \
"
ENV BUILD_DEPS_ARM64V8=$BUILD_DEPS_ARM64V8
ENV BUILD_DEPS=

ARG NGINX_BUILD_DEPS="\
# NGINX
        alpine-sdk \
        bash \
        findutils \
        gcc \
        libc-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
"
ENV NGINX_BUILD_DEPS=$NGINX_BUILD_DEPS

####################################
# Build Nginx with support for LUA #
####################################
FROM base AS builder

# hadolint ignore=SC2086
RUN set -eux \
    && eval BUILD_DEPS="\$$(echo BUILD_DEPS_${ARCH} | tr '[:lower:]' '[:upper:]')" \
    && apk update \
    && apk add --no-cache \
        $BUILD_DEPS \
        $NGINX_BUILD_DEPS

COPY tpl/Makefile Makefile

RUN make deps \
    && make core \
    && make luarocks

##########################################
# Combine everything with minimal layers #
##########################################
FROM base

# http://label-schema.org/rc1/
LABEL maintainer="Fabio Cicerchia <info@fabiocicerchia.it>" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Nginx ${VER_NGINX} with Lua support based on alpine (${ARCH}) 3.17.3." \
    org.label-schema.docker.cmd="docker run -p 80:80 -d ${DOCKER_IMAGE}:${VER_NGINX}-alpine3.17.3" \
    org.label-schema.name="${DOCKER_IMAGE}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/${DOCKER_IMAGE}" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/${DOCKER_IMAGE}" \
    org.label-schema.version="${VER_NGINX}-alpine3.17.3" \
    image.target.platform="${TARGETPLATFORM}" \
    image.target.os="${TARGETOS}" \
    image.target.arch="${ARCH}" \
    versions.lua="${VER_LUA}" \
    versions.luajit2="${VER_LUAJIT}" \
    versions.luarocks="${VER_LUAROCKS}" \
    versions.nginx="${VER_NGINX}" \
    versions.ngx_devel_kit="${VER_NGX_DEVEL_KIT}" \
    versions.njs="${VER_NJS}" \
    versions.os="3.17.3" \
    versions.headers-more-nginx-module="${VER_OPENRESTY_HEADERS}" \
    versions.lua-nginx-module="${VER_LUA_NGINX_MODULE}" \
    versions.lua-resty-cookie="${VER_CLOUDFLARE_COOKIE}" \
    versions.lua-resty-core="${VER_LUA_RESTY_CORE}" \
    versions.lua-resty-dns="${VER_OPENRESTY_DNS}" \
    versions.lua-resty-lrucache="${VER_LUA_RESTY_LRUCACHE}" \
    versions.lua-resty-memcached="${VER_OPENRESTY_MEMCACHED}" \
    versions.set-misc-nginx=${VER_MISC_NGINX} \
    versions.lua-resty-mysql="${VER_OPENRESTY_MYSQL}" \
    versions.lua-resty-redis="${VER_OPENRESTY_REDIS}" \
    versions.lua-resty-shell="${VER_OPENRESTY_SHELL}" \
    versions.lua-resty-signal="${VER_OPENRESTY_SIGNAL}" \
    versions.lua-resty-tablepool="${VER_OPENRESTY_TABLEPOOL}" \
    versions.lua-resty-upstream-healthcheck="${VER_OPENRESTY_HEALTHCHECK}" \
    versions.lua-resty-websocket="${VER_OPENRESTY_WEBSOCKET}" \
    versions.lua-upstream="${VER_LUA_UPSTREAM}" \
    versions.nginx-lua-prometheus="${VER_PROMETHEUS}" \
    versions.stream-lua-nginx-module="${VER_OPENRESTY_STREAMLUA}"

ARG PKG_DEPS="\
        curl \
        geoip-dev \
        libxml2-dev \
        lua${VER_LUA} \
        lua${VER_LUA}-dev \
        openssl-dev \
        pcre-dev \
        unzip \
        zlib-dev \
"
ENV PKG_DEPS=$PKG_DEPS

COPY --from=builder --chown=101:101 /etc/nginx /etc/nginx
COPY --from=builder --chown=101:101 /usr/local/lib /usr/local/lib
COPY --from=builder --chown=101:101 /usr/local/share/lua /usr/local/share/lua
COPY --from=builder --chown=101:101 /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder --chown=101:101 /usr/sbin/nginx-debug /usr/sbin/nginx-debug
COPY --from=builder --chown=101:101 /var/cache/nginx /var/cache/nginx
COPY --from=builder --chown=101:101 /usr/local/bin/luarocks /usr/local/bin/luarocks
COPY --from=builder --chown=101:101 /usr/local/etc/luarocks /usr/local/etc/luarocks

COPY --chown=101:101 tpl/support.sh /
COPY --chown=101:101 tpl/docker-entrypoint.sh /
COPY --chown=101:101 tpl/??-*.sh /docker-entrypoint.d/
COPY --chown=101:101 tpl/nginx.conf /etc/nginx/nginx.conf
COPY --chown=101:101 tpl/default.conf /etc/nginx/conf.d/default.conf

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=SC2086
RUN set -eux \
    && apk update \
    && apk add --no-cache --virtual .pkg_deps \
        $PKG_DEPS \
    && mkdir -p /var/log/nginx \
# Fix LUA alias
    && ln -sf /usr/bin/lua${VER_LUA} /usr/local/bin/lua

RUN set -x \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
# COMMENTED OUT FROM ORIGINAL DOCKERFILE: https://github.com/nginxinc/docker-nginx/blob/1.23.2/mainline/alpine/Dockerfile
# REASON: No need to use the existing distributed package as the binary is recompiled.
#     && apkArch="$(cat /etc/apk/arch)" \
#     && nginxPackages=" \
#         nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
#         nginx-module-xslt=${NGINX_VERSION}-r${PKG_RELEASE} \
#         nginx-module-geoip=${NGINX_VERSION}-r${PKG_RELEASE} \
#         nginx-module-image-filter=${NGINX_VERSION}-r${PKG_RELEASE} \
#         nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${PKG_RELEASE} \
#     " \
# # install prerequisites for public key and pkg-oss checks
#     && apk add --no-cache --virtual .checksum-deps \
#         openssl \
#     && case "$apkArch" in \
#         x86_64|aarch64) \
# # arches officially built by upstream
#             set -x \
#             && KEY_SHA512="e09fa32f0a0eab2b879ccbbc4d0e4fb9751486eedda75e35fac65802cc9faa266425edf83e261137a2f4d16281ce2c1a5f4502930fe75154723da014214f0655" \
#             && wget -O /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
#             && if echo "$KEY_SHA512 */tmp/nginx_signing.rsa.pub" | sha512sum -c -; then \
#                 echo "key verification succeeded!"; \
#                 mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
#             else \
#                 echo "key verification failed!"; \
#                 exit 1; \
#             fi \
#             && apk add -X "https://nginx.org/packages/mainline/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
#             ;; \
#         *) \
# # we're on an architecture upstream doesn't officially build for
# # let's build binaries from the published packaging sources
#             set -x \
#             && tempDir="$(mktemp -d)" \
#             && chown nobody:nobody $tempDir \
#             && apk add --no-cache --virtual .build-deps \
#                 gcc \
#                 libc-dev \
#                 make \
#                 openssl-dev \
#                 pcre2-dev \
#                 zlib-dev \
#                 linux-headers \
#                 bash \
#                 alpine-sdk \
#                 findutils \
#             && su nobody -s /bin/sh -c " \
#                 export HOME=${tempDir} \
#                 && cd ${tempDir} \
#                 && curl -f -O https://hg.nginx.org/pkg-oss/archive/${NGINX_VERSION}-${PKG_RELEASE}.tar.gz \
#                 && PKGOSSCHECKSUM=\"52a80f6c3b3914462f8a0b2fbadea950bcd79c1bd528386aff4c28d5a80c6920d783575a061a47b60fea800eef66bf5a0178a137ea51c37277fe9c2779715990 *${NGINX_VERSION}-${PKG_RELEASE}.tar.gz\" \
#                 && if [ \"\$(openssl sha512 -r ${NGINX_VERSION}-${PKG_RELEASE}.tar.gz)\" = \"\$PKGOSSCHECKSUM\" ]; then \
#                     echo \"pkg-oss tarball checksum verification succeeded!\"; \
#                 else \
#                     echo \"pkg-oss tarball checksum verification failed!\"; \
#                     exit 1; \
#                 fi \
#                 && tar xzvf ${NGINX_VERSION}-${PKG_RELEASE}.tar.gz \
#                 && cd pkg-oss-${NGINX_VERSION}-${PKG_RELEASE} \
#                 && cd alpine \
#                 && make base \
#                 && apk index -o ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz ${tempDir}/packages/alpine/${apkArch}/*.apk \
#                 && abuild-sign -k ${tempDir}/.abuild/abuild-key.rsa ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz \
#                 " \
#             && cp ${tempDir}/.abuild/abuild-key.rsa.pub /etc/apk/keys/ \
#             && apk del .build-deps \
#             && apk add -X ${tempDir}/packages/alpine/ add--no-cache $nginxPackages \
#             ;; \
#     esac \
# # remove checksum deps
#     && apk del .checksum-deps \
# # if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
#     && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi \
#     && if [ -n "/etc/apk/keys/abuild-key.rsa.pub" ]; then rm -f /etc/apk/keys/abuild-key.rsa.pub; fi \
#     && if [ -n "/etc/apk/keys/nginx_signing.rsa.pub" ]; then rm -f /etc/apk/keys/nginx_signing.rsa.pub; fi \
# Bring in gettext so we can get `envsubst`, then throw
# the rest away. To do this, we need to install `gettext`
# then move `envsubst` out of the way so `gettext` can
# be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    \
    && runDeps="$( \
        scanelf --needed --nobanner /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
# Bring in tzdata so users could set the timezones through the environment
# variables
    && apk add --no-cache tzdata \
# forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Upgrade software to latest version
# ##############################################################################
RUN apk upgrade

# smoke test
# ##############################################################################
RUN envsubst -V \
    && nginx -V \
    && nginx -t \
    && lua -v \
    && luarocks --version

EXPOSE 80 443

HEALTHCHECK --interval=30s --timeout=3s CMD curl --fail http://localhost/ || exit 1

# Override stop signal to stop process gracefully
STOPSIGNAL SIGQUIT

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
