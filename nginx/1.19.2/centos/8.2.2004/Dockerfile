#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2023 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

#############################
# Settings Common Variables #
#############################
FROM centos:8.2.2004 AS base

ARG DOCKER_IMAGE=fabiocicerchia/nginx-lua
ENV DOCKER_IMAGE=$DOCKER_IMAGE
ARG DOCKER_IMAGE_OS=centos
ENV DOCKER_IMAGE_OS=$DOCKER_IMAGE_OS
ARG DOCKER_IMAGE_TAG=8.2.2004
ENV DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG

ARG BUILD_DATE
ENV BUILD_DATE=$BUILD_DATE
ARG VCS_REF
ENV VCS_REF=$VCS_REF

ARG EXTENDED_IMAGE=1
ENV EXTENDED_IMAGE=$EXTENDED_IMAGE

# ngx_devel_kit
# https://github.com/vision5/ngx_devel_kit
# The NDK is now considered to be stable.
ARG VER_NGX_DEVEL_KIT=0.3.1
ENV VER_NGX_DEVEL_KIT=$VER_NGX_DEVEL_KIT

# luajit2
# https://github.com/openresty/luajit2
ARG VER_LUAJIT=2.1-20201002
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
ARG VER_LUA_NGINX_MODULE=0.10.17
ENV VER_LUA_NGINX_MODULE=$VER_LUA_NGINX_MODULE

# lua-resty-core
# https://github.com/openresty/lua-resty-core
# This library is production ready.
ARG VER_LUA_RESTY_CORE=0.1.19
ENV VER_LUA_RESTY_CORE=$VER_LUA_RESTY_CORE
ARG LUA_LIB_DIR=/usr/local/share/lua/5.1
ENV LUA_LIB_DIR=$LUA_LIB_DIR

# lua-resty-lrucache
# https://github.com/openresty/lua-resty-lrucache
# This library is considered production ready.
ARG VER_LUA_RESTY_LRUCACHE=0.10
ENV VER_LUA_RESTY_LRUCACHE=$VER_LUA_RESTY_LRUCACHE

# headers-more-nginx-module
# https://github.com/openresty/headers-more-nginx-module
ARG VER_OPENRESTY_HEADERS=d6d7ebab3c0c5b32ab421ba186783d3e5d2c6a17
ENV VER_OPENRESTY_HEADERS=$VER_OPENRESTY_HEADERS

# lua-resty-cookie
# https://github.com/cloudflare/lua-resty-cookie
ARG VER_CLOUDFLARE_COOKIE=303e32e512defced053a6484bc0745cf9dc0d39e
ENV VER_CLOUDFLARE_COOKIE=$VER_CLOUDFLARE_COOKIE

# lua-resty-dns
# https://github.com/openresty/lua-resty-dns
ARG VER_OPENRESTY_DNS=0.21
ENV VER_OPENRESTY_DNS=$VER_OPENRESTY_DNS

# lua-resty-memcached
# https://github.com/openresty/lua-resty-memcached
ARG VER_OPENRESTY_MEMCACHED=0.15
ENV VER_OPENRESTY_MEMCACHED=$VER_OPENRESTY_MEMCACHED

# lua-resty-mysql
# https://github.com/openresty/lua-resty-mysql
ARG VER_OPENRESTY_MYSQL=0.22
ENV VER_OPENRESTY_MYSQL=$VER_OPENRESTY_MYSQL

# lua-resty-redis
# https://github.com/openresty/lua-resty-redis
ARG VER_OPENRESTY_REDIS=0.28
ENV VER_OPENRESTY_REDIS=$VER_OPENRESTY_REDIS

# lua-resty-shell
# https://github.com/openresty/lua-resty-shell
ARG VER_OPENRESTY_SHELL=0.03
ENV VER_OPENRESTY_SHELL=$VER_OPENRESTY_SHELL

# lua-resty-upstream-healthcheck
# https://github.com/openresty/lua-resty-upstream-healthcheck
ARG VER_OPENRESTY_HEALTHCHECK=0.06
ENV VER_OPENRESTY_HEALTHCHECK=$VER_OPENRESTY_HEALTHCHECK

# lua-resty-websocket
# https://github.com/openresty/lua-resty-websocket
ARG VER_OPENRESTY_WEBSOCKET=0.07
ENV VER_OPENRESTY_WEBSOCKET=$VER_OPENRESTY_WEBSOCKET

# lua-upstream-nginx-module
# https://github.com/openresty/lua-upstream-nginx-module
ARG VER_LUA_UPSTREAM=0.07
ENV VER_LUA_UPSTREAM=$VER_LUA_UPSTREAM

# nginx-lua-prometheus
# https://github.com/knyar/nginx-lua-prometheus
ARG VER_PROMETHEUS=0.20200523
ENV VER_PROMETHEUS=$VER_PROMETHEUS

# stream-lua-nginx-module
# https://github.com/openresty/stream-lua-nginx-module
ARG VER_OPENRESTY_STREAMLUA=0.0.8
ENV VER_OPENRESTY_STREAMLUA=$VER_OPENRESTY_STREAMLUA

# https://github.com/nginx/nginx
ARG VER_NGINX=1.19.2
ENV VER_NGINX=$VER_NGINX
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
          --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
          --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
          --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
          --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
          --user=nginx \
          --group=nginx \
          --add-module=/lua-nginx-module-${VER_LUA_NGINX_MODULE} \
          --add-module=/ngx_devel_kit-${VER_NGX_DEVEL_KIT} \
          --add-module=/lua-upstream-nginx-module-${VER_LUA_UPSTREAM} \
          --with-compat \
          --with-file-aio \
          --with-http_addition_module \
          --with-http_auth_request_module \
          --with-http_dav_module \
          --with-http_dav_module \
          --with-http_flv_module \
          --with-http_geoip_module \
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
          --with-threads \
    "
ENV NGINX_BUILD_CONFIG=$NGINX_BUILD_CONFIG

ARG BUILD_DEPS="\
      GeoIP-devel \
      ca-certificates \
      gcc-c++ \
      gzip \
      make \
      openssl-devel \
      pcre-devel \
      tar \
      unzip \
      zlib-devel"
ENV BUILD_DEPS=$BUILD_DEPS

ARG NGINX_BUILD_DEPS=""
ENV NGINX_BUILD_DEPS=$NGINX_BUILD_DEPS

# dumb-init
# https://github.com/Yelp/dumb-init
ARG VER_DUMBINIT=1.2.2
ENV VER_DUMBINIT=$VER_DUMBINIT

####################################
# Build Nginx with support for LUA #
####################################
FROM base AS builder

RUN set -x \
    && yum makecache \
    && yum install -y epel-release \
    && yum install -y \
      $BUILD_DEPS \
      $NGINX_BUILD_DEPS

RUN set -eux \
# NGX Devel Kit
# ##############################################################################
    && curl -Lo /ngx_devel_kit.tar.gz https://github.com/vision5/ngx_devel_kit/archive/v${VER_NGX_DEVEL_KIT}.tar.gz \
    && tar -C / -xvzf /ngx_devel_kit.tar.gz \
    \
# OpenResty LUAJIT2
# ##############################################################################
    && curl -Lo /luajit.tar.gz https://github.com/openresty/luajit2/archive/v${VER_LUAJIT}.tar.gz \
    && tar -C / -xvzf /luajit.tar.gz \
    && cd /luajit2-${VER_LUAJIT} \
    && make -j "$(nproc)" \
    && make install \
    \
# Lua Nginx Module
# ##############################################################################
    && curl -Lo /lua-nginx.tar.gz https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz \
    && tar -C / -xvzf /lua-nginx.tar.gz \
# LUA Resty Core
# ##############################################################################
    && curl -Lo /lua-resty-core.tar.gz https://github.com/openresty/lua-resty-core/archive/v${VER_LUA_RESTY_CORE}.tar.gz \
    && tar -C / -xvzf /lua-resty-core.tar.gz \
    && cd /lua-resty-core-${VER_LUA_RESTY_CORE} \
    && make -j "$(nproc)" \
    && make install \
    \
# LUA Resty LRUCache
# ##############################################################################
    && curl -Lo /lua-resty-lrucache.tar.gz https://github.com/openresty/lua-resty-lrucache/archive/v${VER_LUA_RESTY_LRUCACHE}.tar.gz \
    && tar -C / -xvzf /lua-resty-lrucache.tar.gz \
    && cd /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
    && make -j "$(nproc)" \
    && make install \
    \
# OpenResty Headers
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /headers-more-nginx-module.zip https://github.com/openresty/headers-more-nginx-module/archive/${VER_OPENRESTY_HEADERS}.zip \
    && unzip -d / /headers-more-nginx-module.zip) \
# Cloudflare Cookie
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /lua-resty-cookie.tar.gz https://github.com/cloudflare/lua-resty-cookie/archive/${VER_CLOUDFLARE_COOKIE}.tar.gz \
    && tar -C / -xvzf /lua-resty-cookie.tar.gz \
    && cd /lua-resty-cookie-${VER_CLOUDFLARE_COOKIE} \
    && make -j "$(nproc)") \
# OpenResty Dns
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /lua-openresty-dns.tar.gz https://github.com/openresty/lua-resty-dns/archive/v${VER_OPENRESTY_DNS}.tar.gz \
    && tar -C / -xvzf /lua-openresty-dns.tar.gz \
    && cd /lua-resty-dns-${VER_OPENRESTY_DNS} \
    && make -j "$(nproc)" \
    && make install) \
# OpenResty Memcached
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /lua-openresty-memcached.tar.gz https://github.com/openresty/lua-resty-memcached/archive/v${VER_OPENRESTY_MEMCACHED}.tar.gz \
    && tar -C / -xvzf /lua-openresty-memcached.tar.gz \
    && cd /lua-resty-memcached-${VER_OPENRESTY_MEMCACHED} \
    && make -j "$(nproc)" \
    && make install) \
# OpenResty Mysql
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /lua-openresty-mysql.tar.gz https://github.com/openresty/lua-resty-mysql/archive/v${VER_OPENRESTY_MYSQL}.tar.gz \
    && tar -C / -xvzf /lua-openresty-mysql.tar.gz \
    && cd /lua-resty-mysql-${VER_OPENRESTY_MYSQL} \
    && make -j "$(nproc)" \
    && make install) \
# OpenResty Redis
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /lua-openresty-redis.tar.gz https://github.com/openresty/lua-resty-redis/archive/v${VER_OPENRESTY_REDIS}.tar.gz \
    && tar -C / -xvzf /lua-openresty-redis.tar.gz \
    && cd /lua-resty-redis-${VER_OPENRESTY_REDIS} \
    && make -j "$(nproc)" \
    && make install) \
# OpenResty Shell
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /lua-openresty-shell.tar.gz https://github.com/openresty/lua-resty-shell/archive/v${VER_OPENRESTY_SHELL}.tar.gz \
    && tar -C / -xvzf /lua-openresty-shell.tar.gz \
    && cd /lua-resty-shell-${VER_OPENRESTY_SHELL} \
    && make -j "$(nproc)" \
    && make install) \
# OpenResty Upstream Healthcheck
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /lua-resty-upstream-healthcheck.tar.gz https://github.com/openresty/lua-resty-upstream-healthcheck/archive/v${VER_OPENRESTY_HEALTHCHECK}.tar.gz \
    && tar -C / -xvzf /lua-resty-upstream-healthcheck.tar.gz \
    && cd /lua-resty-upstream-healthcheck-${VER_OPENRESTY_HEALTHCHECK} \
    && make -j "$(nproc)" \
    && make install) \
# OpenResty Websocket
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /lua-openresty-websocket.tar.gz https://github.com/openresty/lua-resty-websocket/archive/v${VER_OPENRESTY_WEBSOCKET}.tar.gz \
    && tar -C / -xvzf /lua-openresty-websocket.tar.gz \
    && cd /lua-resty-websocket-${VER_OPENRESTY_WEBSOCKET} \
    && make -j "$(nproc)" \
    && make install) \
# LUA Upstream
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /lua-upstream-nginx-module.tar.gz https://github.com/openresty/lua-upstream-nginx-module/archive/v${VER_LUA_UPSTREAM}.tar.gz \
    && tar -C / -xvzf /lua-upstream-nginx-module.tar.gz \
    && cd /lua-upstream-nginx-module-${VER_LUA_UPSTREAM}) \
# Prometheus
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /nginx-lua-prometheus.tar.gz https://github.com/knyar/nginx-lua-prometheus/archive/${VER_PROMETHEUS}.tar.gz \
    && tar -C / -xvzf /nginx-lua-prometheus.tar.gz \
    && mv /nginx-lua-prometheus-${VER_PROMETHEUS}/*.lua ${LUA_LIB_DIR}/) \
# OpenResty Stream Lua
# ##############################################################################
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    curl -Lo /stream-lua-nginx-module.zip https://github.com/openresty/stream-lua-nginx-module/archive/v${VER_OPENRESTY_STREAMLUA}.zip \
    && unzip -d / /stream-lua-nginx-module.zip)

RUN set -eux \
# NGINX
# ##############################################################################
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published packaging sources
    && curl -Lo /nginx.tar.gz https://nginx.org/download/nginx-${VER_NGINX}.tar.gz \
    && tar -C / -xvzf /nginx.tar.gz \
    && cd /nginx-${VER_NGINX} \
    && mkdir -p /var/cache/nginx/client_temp \
        /var/cache/nginx/proxy_temp \
        /var/cache/nginx/fastcgi_temp \
        /var/cache/nginx/uwsgi_temp \
        /var/cache/nginx/scgi_temp \
    && [ $EXTENDED_IMAGE -eq 1 ] && ( \
    ./configure \
        ${NGINX_BUILD_CONFIG} \
        --add-module=/headers-more-nginx-module-${VER_OPENRESTY_HEADERS} \
        --add-module=/stream-lua-nginx-module-${VER_OPENRESTY_STREAMLUA} \
        --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
        --with-ld-opt='-Wl,-rpath,/usr/local/lib -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie') \
    || (./configure \
        ${NGINX_BUILD_CONFIG} \
        --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
        --with-ld-opt='-Wl,-rpath,/usr/local/lib -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie') \
    && make -j "$(nproc)" build \
    && make install

##########################################
# Combine everything with minimal layers #
##########################################
FROM base

# http://label-schema.org/rc1/
LABEL maintainer="Fabio Cicerchia <info@fabiocicerchia.it>" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.description="Nginx $VER_NGINX with Lua support based on $DOCKER_IMAGE_OS $DOCKER_IMAGE_TAG." \
      org.label-schema.docker.cmd="docker run -p 80:80 -d $DOCKER_IMAGE:$VER_NGINX-$DOCKER_IMAGE_OS$DOCKER_IMAGE_TAG" \
      org.label-schema.name="$DOCKER_IMAGE" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="https://github.com/$DOCKER_IMAGE" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/$DOCKER_IMAGE" \
      org.label-schema.version="$VER_NGINX-$DOCKER_IMAGE_OS$DOCKER_IMAGE_TAG" \
      versions.extended=${EXTENDED_IMAGE} \
      versions.dumb-init=${VER_DUMBINIT} \
      versions.headers-more-nginx-module=${VER_OPENRESTY_HEADERS} \
      versions.lua-nginx-module=${VER_LUA_NGINX_MODULE} \
      versions.lua-resty-cookie=${VER_CLOUDFLARE_COOKIE} \
      versions.lua-resty-core=${VER_LUA_RESTY_CORE} \
      versions.lua-resty-dns=${VER_OPENRESTY_DNS} \
      versions.lua-resty-lrucache=${VER_LUA_RESTY_LRUCACHE} \
      versions.lua-resty-memcached=${VER_OPENRESTY_MEMCACHED} \
      versions.lua-resty-mysql=${VER_OPENRESTY_MYSQL} \
      versions.lua-resty-redis=${VER_OPENRESTY_REDIS} \
      versions.lua-resty-shell=${VER_OPENRESTY_SHELL} \
      versions.lua-resty-upstream-healthcheck=${VER_OPENRESTY_HEALTHCHECK} \
      versions.lua-resty-websocket=${VER_OPENRESTY_WEBSOCKET} \
      versions.lua-upstream=${VER_LUA_UPSTREAM} \
      versions.luajit2=${VER_LUAJIT} \
      versions.nginx-lua-prometheus=${VER_PROMETHEUS} \
      versions.nginx=${VER_NGINX} \
      versions.ngx_devel_kit=${VER_NGX_DEVEL_KIT} \
      versions.os=${DOCKER_IMAGE_TAG} \
      versions.stream-lua-nginx-module=${VER_OPENRESTY_STREAMLUA}

ARG PKG_DEPS="\
      GeoIP-devel \
      ca-certificates \
      openssl-devel \
      pcre-devel \
      zlib-devel"
ENV PKG_DEPS=$PKG_DEPS

COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/share/lua /usr/local/share/lua
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder /var/cache/nginx /var/cache/nginx

RUN set -eux \
    && yum makecache \
    && yum install -y epel-release \
    && yum install -y \
        $PKG_DEPS \
# Bring in tzdata so users could set the timezones through the environment
# variables
    && yum install -y tzdata \
# Bring in curl and ca-certificates to make registering on DNS SD easier
    && yum install -y curl ca-certificates \
# forward request and error logs to docker log collector
    && mkdir -p /var/log/nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
# dumb-init
# ##############################################################################
    && curl -Lo /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${VER_DUMBINIT}/dumb-init_${VER_DUMBINIT}_x86_64 \
    && chmod +x /usr/bin/dumb-init \
# create nginx user/group first, to be consistent throughout docker variants
    && groupadd --system --gid 32548 nginx \
    && useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 32548 nginx \
# Cleanup
# ##############################################################################
    && yum clean all \
    && rm -rf /var/cache/yum \
# smoke test
# ##############################################################################
    && nginx -V \
    && nginx -t

HEALTHCHECK --interval=30s --timeout=3s CMD curl --fail http://localhost/ || exit 1

EXPOSE 80 443

# Override stop signal to stop process gracefully
STOPSIGNAL SIGQUIT

ENTRYPOINT ["dumb-init"]

CMD ["nginx", "-g", "daemon off;"]
