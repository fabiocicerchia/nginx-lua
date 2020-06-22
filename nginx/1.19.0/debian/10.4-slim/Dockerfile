FROM debian:10.4-slim

MAINTAINER Fabio Cicerchia <info@fabiocicerchia.it>
LABEL maintainer="info@fabiocicerchia.it"

ARG BUILD_DATE
ARG BUILD_VERSION
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="fabiocicerchia/nginx-lua"
LABEL org.label-schema.description="Nginx 1.19.0 with LUA support based on debian 10.4-slim."
LABEL org.label-schema.url="https://github.com/fabiocicerchia/nginx-lua"
LABEL org.label-schema.vcs-url="https://github.com/fabiocicerchia/nginx-lua"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.19.0-debian10.4-slim"

# https://github.com/openresty/luajit2
ENV VER_LUAJIT 2.1-20200102

# https://github.com/openresty/lua-nginx-module
# Production ready.
ENV VER_LUA_NGINX_MODULE 0.10.15

# https://github.com/openresty/lua-resty-core
# This library is production ready.
ENV VER_LUA_RESTY_CORE 0.1.17
ENV LUA_LIB_DIR /usr/local/share/lua/5.1

# https://github.com/openresty/lua-resty-lrucache
# This library is considered production ready.
ENV VER_LUA_RESTY_LRUCACHE 0.09

# https://github.com/nginx/nginx
ENV VER_NGINX 1.19.0

# https://github.com/vision5/ngx_devel_kit
# The NDK is now considered to be stable.
ENV VER_NGX_DEVEL_KIT 0.3.1

ENV LUAJIT_LIB /usr/local/lib
ENV LUAJIT_INC /usr/local/include/luajit-2.1
ENV LD_LIBRARY_PATH /usr/local/lib/:$LD_LIBRARY_PATH
ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
   && apt-get update \
   && apt-get install -y --no-install-recommends --no-install-suggests \
      ca-certificates \
      libgeoip-dev \
      libpcre3-dev \
      libssl-dev \
      zlib1g-dev \
   && apt-get install -y --no-install-recommends --no-install-suggests \
      g++ \
      gzip \
      make \
      tar \
      wget \
# OpenResty LUAJIT2
# ##############################################################################
   && wget https://github.com/openresty/luajit2/archive/v${VER_LUAJIT}.tar.gz -O /luajit.tar.gz \
      && tar xvzf /luajit.tar.gz && rm /luajit.tar.gz \
      && cd /luajit2-${VER_LUAJIT} \
      && make -j $(nproc) \
      && make install \
      && cd / \
# LUA Resty Core
# ##############################################################################
   && wget https://github.com/openresty/lua-resty-core/archive/v${VER_LUA_RESTY_CORE}.tar.gz -O /lua-resty-core.tar.gz \
      && tar xvzf /lua-resty-core.tar.gz && rm /lua-resty-core.tar.gz \
      && cd /lua-resty-core-${VER_LUA_RESTY_CORE} \
      && make -j $(nproc) \
      && make install \
      && cd / \
# LUA Resty LRUCache
# ##############################################################################
   && wget https://github.com/openresty/lua-resty-lrucache/archive/v${VER_LUA_RESTY_LRUCACHE}.tar.gz -O /lua-resty-lrucache.tar.gz \
      && tar xvzf /lua-resty-lrucache.tar.gz && rm /lua-resty-lrucache.tar.gz \
      && cd /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
      && make -j $(nproc) \
      && make install \
      && cd / \
# NGX Devel Kit
# ##############################################################################
   && wget https://github.com/vision5/ngx_devel_kit/archive/v${VER_NGX_DEVEL_KIT}.tar.gz -O /ngx_devel_kit.tar.gz \
      && tar xvzf /ngx_devel_kit.tar.gz && rm /ngx_devel_kit.tar.gz \
# Lua Nginx Module
# ##############################################################################
   && wget https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz -O /lua-nginx.tar.gz \
      && tar xvzf /lua-nginx.tar.gz && rm /lua-nginx.tar.gz \
# NGINX
# ##############################################################################
# create nginx user/group first, to be consistent throughout docker variants
   && addgroup --system --gid 1001 nginx \
   && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 1001 nginx \
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published packaging sources
      && wget https://nginx.org/download/nginx-${VER_NGINX}.tar.gz -O /nginx.tar.gz \
      && tar xvzf /nginx.tar.gz && rm /nginx.tar.gz \
      && cd /nginx-${VER_NGINX} \
      && mkdir -p /var/cache/nginx/client_temp \
         /var/cache/nginx/proxy_temp \
         /var/cache/nginx/fastcgi_temp \
         /var/cache/nginx/uwsgi_temp \
         /var/cache/nginx/scgi_temp \
      && ./configure \
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
         --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
         --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
         --add-module=/lua-nginx-module-${VER_LUA_NGINX_MODULE} \
         --add-module=/ngx_devel_kit-${VER_NGX_DEVEL_KIT} \
         --with-http_dav_module \
         --with-http_geoip_module \
      && make -j $(nproc) build \
      && make install \
# Bring in tzdata so users could set the timezones through the environment
# variables
   && apt-get install -y --no-install-recommends --no-install-suggests tzdata \
# Bring in curl and ca-certificates to make registering on DNS SD easier
   && apt-get install -y --no-install-recommends --no-install-suggests curl ca-certificates \
# forward request and error logs to docker log collector
   && ln -sf /dev/stdout /var/log/nginx/access.log \
   && ln -sf /dev/stderr /var/log/nginx/error.log \
# Cleanup
# ##############################################################################
   && rm -rf /lua-nginx-module-${VER_LUA_NGINX_MODULE} \
   && rm -rf /lua-resty-core-${VER_LUA_RESTY_CORE} \
   && rm -rf /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
   && rm -rf /luajit2-${VER_LUAJIT} \
   && rm -rf /nginx-${VER_NGINX} \
   && rm -rf /ngx_devel_kit-${VER_NGX_DEVEL_KIT} \
   && apt-get remove -y \
      g++ \
      make \
      wget \
   && rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=30s --timeout=3s CMD curl --fail http://localhost/ || exit 1

EXPOSE 80
EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
