#!/bin/bash

get_latest_tag() {
    git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' $1 | grep -vE "rc|alpha|beta|{}" | tail -n 1 | sed 's#.*refs/tags/v\?##' | xargs
}

get_latest_commit() {
    git -c 'versionsort.suffix=-' ls-remote --sort='v:refname' $1 HEAD | head -n 1 | sed 's#\t.*##' | xargs
}

echo "# NGINX MODULES"
echo "################################################################################"
echo ""
echo "# ngx_devel_kit"
echo "# https://github.com/vision5/ngx_devel_kit/releases"
echo "# The NDK is now considered to be stable."
echo "VER_NGX_DEVEL_KIT="$(get_latest_tag "https://github.com/vision5/ngx_devel_kit")
echo ""
echo "# njs"
echo "# https://github.com/nginx/njs/tags"
echo "VER_NJS="$(get_latest_tag "https://github.com/nginx/njs")
echo ""
echo "# geoip2"
echo "# https://github.com/leev/ngx_http_geoip2_module/releases"
echo "VER_GEOIP="$(get_latest_tag "https://github.com/leev/ngx_http_geoip2_module")
echo ""
echo "# LUA"
echo "################################################################################"
echo ""
echo "# luajit2"
echo "# https://github.com/openresty/luajit2/tags"
echo "# Note: LuaJIT2 is stuck on Lua 5.1 since 2009."
echo "VER_LUAJIT="$(get_latest_tag "https://github.com/openresty/luajit2")
echo ""
echo "# lua-nginx-module"
echo "# https://github.com/openresty/lua-nginx-module/tags"
echo "# Production ready."
echo "VER_LUA_NGINX_MODULE="$(get_latest_tag "https://github.com/openresty/lua-nginx-module")
echo ""
echo "# lua-resty-core"
echo "# https://github.com/openresty/lua-resty-core/tags"
echo "# This library is production ready."
echo "VER_LUA_RESTY_CORE="$(get_latest_tag "https://github.com/openresty/lua-resty-core")
echo ""
echo "# LUAROCKS"
echo "################################################################################"
echo ""
echo "# lua-rocks"
echo "# https://github.com/luarocks/luarocks/tags"
echo "VER_LUAROCKS="$(get_latest_tag "https://github.com/luarocks/luarocks")
echo ""
echo "# LUA ADDONS"
echo "################################################################################"
echo ""
echo "# lua-resty-lrucache"
echo "# https://github.com/openresty/lua-resty-lrucache/tags"
echo "# This library is considered production ready."
echo "VER_LUA_RESTY_LRUCACHE="$(get_latest_tag "https://github.com/openresty/lua-resty-lrucache")
echo ""
echo "# headers-more-nginx-module"
echo "# https://github.com/openresty/headers-more-nginx-module/tags"
echo "VER_OPENRESTY_HEADERS="$(get_latest_tag "https://github.com/openresty/headers-more-nginx-module")
echo ""
echo "# lua-resty-cookie"
echo "# https://github.com/cloudflare/lua-resty-cookie/commits/master"
echo "VER_CLOUDFLARE_COOKIE="$(get_latest_commit "https://github.com/cloudflare/lua-resty-cookie")
echo ""
echo "# lua-resty-dns"
echo "# https://github.com/openresty/lua-resty-dns/tags"
echo "VER_OPENRESTY_DNS="$(get_latest_tag "https://github.com/openresty/lua-resty-dns")
echo ""
echo "# lua-resty-memcached"
echo "# https://github.com/openresty/lua-resty-memcached/tags"
echo "VER_OPENRESTY_MEMCACHED="$(get_latest_tag "https://github.com/openresty/lua-resty-memcached")
echo ""
echo "# lua-resty-mysql"
echo "# https://github.com/openresty/lua-resty-mysql/tags"
echo "VER_OPENRESTY_MYSQL="$(get_latest_tag "https://github.com/openresty/lua-resty-mysql")
echo ""
echo "# lua-resty-redis"
echo "# https://github.com/openresty/lua-resty-redis/tags"
echo "VER_OPENRESTY_REDIS="$(get_latest_tag "https://github.com/openresty/lua-resty-redis")
echo ""
echo "# lua-resty-shell"
echo "# https://github.com/openresty/lua-resty-shell/tags"
echo "VER_OPENRESTY_SHELL="$(get_latest_tag "https://github.com/openresty/lua-resty-shell")
echo ""
echo "# lua-resty-signal"
echo "# https://github.com/openresty/lua-resty-signal/tags"
echo "VER_OPENRESTY_SIGNAL="$(get_latest_tag "https://github.com/openresty/lua-resty-signal")
echo ""
echo "# lua-tablepool"
echo "# https://github.com/openresty/lua-tablepool/tags"
echo "VER_OPENRESTY_TABLEPOOL="$(get_latest_tag "https://github.com/openresty/lua-tablepool")
echo ""
echo "# lua-resty-upstream-healthcheck"
echo "# https://github.com/openresty/lua-resty-upstream-healthcheck/tags"
echo "VER_OPENRESTY_HEALTHCHECK="$(get_latest_tag "https://github.com/openresty/lua-resty-upstream-healthcheck")
echo ""
echo "# lua-resty-websocket"
echo "# https://github.com/openresty/lua-resty-websocket/tags"
echo "VER_OPENRESTY_WEBSOCKET="$(get_latest_tag "https://github.com/openresty/lua-resty-websocket")
echo ""
echo "# lua-upstream-nginx-module"
echo "# https://github.com/openresty/lua-upstream-nginx-module/tags"
echo "VER_LUA_UPSTREAM="$(get_latest_tag "https://github.com/openresty/lua-upstream-nginx-module")
echo ""
echo "# nginx-lua-prometheus"
echo "# https://github.com/knyar/nginx-lua-prometheus/tags"
echo "VER_PROMETHEUS="$(get_latest_tag "https://github.com/knyar/nginx-lua-prometheus")
echo ""
echo "# set-misc-nginx-module"
echo "# https://github.com/openresty/set-misc-nginx-module/tags"
echo "VER_MISC_NGINX="$(get_latest_tag "https://github.com/openresty/set-misc-nginx-module")
echo ""
echo "# stream-lua-nginx-module"
echo "# https://github.com/openresty/stream-lua-nginx-module/tags"
echo "VER_OPENRESTY_STREAMLUA="$(get_latest_tag "https://github.com/openresty/stream-lua-nginx-module")
echo ""
echo "# lua-resty-limit-traffic"
echo "# https://github.com/openresty/lua-resty-limit-traffic/tags"
echo "VER_OPENRESTY_LIMITTRAFFIC="$(get_latest_tag "https://github.com/openresty/lua-resty-limit-traffic")
echo ""
echo "# lua-resty-upload"
echo "# https://github.com/openresty/lua-resty-upload/tags"
echo "VER_OPENRESTY_UPLOAD="$(get_latest_tag "https://github.com/openresty/lua-resty-upload")
echo ""
echo "# lua-resty-lock"
echo "# https://github.com/openresty/lua-resty-lock/tags"
echo "VER_OPENRESTY_LOCK="$(get_latest_tag "https://github.com/openresty/lua-resty-lock")
echo ""
echo "# lua-resty-balancer"
echo "# https://github.com/openresty/lua-resty-balancer/tags"
echo "VER_OPENRESTY_BALANCER="$(get_latest_tag "https://github.com/openresty/lua-resty-balancer")
echo ""
echo "# lua-resty-string"
echo "# https://github.com/openresty/lua-resty-string/tags"
echo "VER_OPENRESTY_STRING="$(get_latest_tag "https://github.com/openresty/lua-resty-string")
echo ""
