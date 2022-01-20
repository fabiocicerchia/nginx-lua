#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2022 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

EXTENDED_IMAGE=YES
NPROC := $(shell nproc)

# ##############################################################################
# CORE
# ##############################################################################

core:
# NGINX
# ##############################################################################
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published packaging sources
# TODO: need to get all patches from openresty?
# TODO: Find a better way to fallback when openresty is behind the nginx latest version and no patch is available
	curl -sLo /nginx.tar.gz https://nginx.org/download/nginx-${VER_NGINX}.tar.gz
	tar -C / -xvzf /nginx.tar.gz
	mkdir -p /var/cache/nginx/client_temp \
		/var/cache/nginx/proxy_temp \
		/var/cache/nginx/fastcgi_temp \
		/var/cache/nginx/uwsgi_temp \
		/var/cache/nginx/scgi_temp
	cd /nginx-${VER_NGINX} \
		&& (curl --fail -sLo nginx-socket_cloexec.patch https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-${VER_NGINX}-socket_cloexec.patch || \
			curl -sLo nginx-socket_cloexec.patch https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.21.4-socket_cloexec.patch) \
		&& patch -p1 < nginx-socket_cloexec.patch || exit 1 \
	&& ./configure ${NGINX_BUILD_CONFIG} --with-cc-opt="$(NGX_CFLAGS)" --with-ld-opt="$(NGX_LDOPT)" --with-debug \
	&& make -j $(NPROC) build \
	&& mv objs/nginx objs/nginx-debug \
	&& ./configure ${NGINX_BUILD_CONFIG} --with-cc-opt="$(NGX_CFLAGS)" --with-ld-opt="$(NGX_LDOPT)" \
	&& make -j $(NPROC) build \
	&& make -j $(NPROC) modules \
	&& install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
	&& make -j $(NPROC) install

# ##############################################################################
# DEPENDENCIES
# ##############################################################################

deps: dep-ngx_devel_kit dep-luajit dep-lua-nginx dep-lua-resty-core dep-lua-resty-lrucache
ifeq ($(EXTENDED_IMAGE), YES)
	make dep-headers-more-nginx-module dep-lua-resty-cookie dep-lua-openresty-dns dep-lua-openresty-memcached dep-lua-openresty-mysql dep-lua-openresty-redis dep-lua-openresty-shell dep-lua-openresty-tablepool dep-lua-openresty-signal dep-lua-resty-upstream-healthcheck dep-lua-openresty-websocket dep-lua-upstream-nginx-module dep-nginx-lua-prometheus dep-stream-lua-nginx-module dep-lua-openresty-misc
endif

# NGX Devel Kit
# ##############################################################################
dep-ngx_devel_kit:
	curl -sLo /ngx_devel_kit.tar.gz https://github.com/vision5/ngx_devel_kit/archive/v${VER_NGX_DEVEL_KIT}.tar.gz
	tar -C / -xvzf /ngx_devel_kit.tar.gz

# OpenResty LUAJIT2
# ##############################################################################
dep-luajit:
	curl -sLo /luajit.tar.gz https://github.com/openresty/luajit2/archive/v${VER_LUAJIT}.tar.gz
	tar -C / -xvzf /luajit.tar.gz
	cd /luajit2-${VER_LUAJIT} \
	&& make \
	&& make install
# This is because OpenResty LuaJIT2 is stuck on Lua 5.1 since 2009.
# Also, since LUA_LIB_DIR is set on 5.4, the 5.1 folder is always empty and nginx
# will try to look things in the wrong one, unless provided with:
#  lua_package_path '/usr/local/share/lua/5.4/?.lua;;';
#  lua_package_cpath '/usr/local/lib/lua/5.4/?.so;;';
# it is safe to delete the folders as they have JUST been created
	rm -r /usr/local/lib/lua/5.1 /usr/local/share/lua/5.1
	ln -s /usr/local/lib/lua/5.4 /usr/local/lib/lua/5.1
	ln -s /usr/local/share/lua/5.4 /usr/local/share/lua/5.1

# Lua Nginx Module
# ##############################################################################
dep-lua-nginx:
	curl -sLo /lua-nginx.tar.gz https://github.com/openresty/lua-nginx-module/archive/${VER_LUA_NGINX_MODULE}.tar.gz
	tar -C / -xvzf /lua-nginx.tar.gz

# LUA Resty Core
# ##############################################################################
dep-lua-resty-core:
	curl -sLo /lua-resty-core.tar.gz https://github.com/openresty/lua-resty-core/archive/${VER_LUA_RESTY_CORE}.tar.gz
	tar -C / -xvzf /lua-resty-core.tar.gz
	cd /lua-resty-core-${VER_LUA_RESTY_CORE} \
	&& make \
	&& make install

# LUA Resty LRUCache
# ##############################################################################
dep-lua-resty-lrucache:
	curl -sLo /lua-resty-lrucache.tar.gz https://github.com/openresty/lua-resty-lrucache/archive/v${VER_LUA_RESTY_LRUCACHE}.tar.gz
	tar -C / -xvzf /lua-resty-lrucache.tar.gz
	cd /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
	&& make \
	&& make install

# OpenResty Headers
# ##############################################################################
dep-headers-more-nginx-module:
	curl -sLo /headers-more-nginx-module.zip https://github.com/openresty/headers-more-nginx-module/archive/v${VER_OPENRESTY_HEADERS}.zip
	unzip -d / /headers-more-nginx-module.zip

# Cloudflare Cookie
# ##############################################################################
dep-lua-resty-cookie:
	curl -sLo /lua-resty-cookie.tar.gz https://github.com/cloudflare/lua-resty-cookie/archive/${VER_CLOUDFLARE_COOKIE}.tar.gz
	tar -C / -xvzf /lua-resty-cookie.tar.gz
	cd /lua-resty-cookie-${VER_CLOUDFLARE_COOKIE} \
	&& make \
	&& make install

# OpenResty Dns
# ##############################################################################
dep-lua-openresty-dns:
	curl -sLo /lua-openresty-dns.tar.gz https://github.com/openresty/lua-resty-dns/archive/v${VER_OPENRESTY_DNS}.tar.gz
	tar -C / -xvzf /lua-openresty-dns.tar.gz
	cd /lua-resty-dns-${VER_OPENRESTY_DNS} \
	&& make \
	&& make install

# OpenResty Memcached
# ##############################################################################
dep-lua-openresty-memcached:
	curl -sLo /lua-openresty-memcached.tar.gz https://github.com/openresty/lua-resty-memcached/archive/v${VER_OPENRESTY_MEMCACHED}.tar.gz
	tar -C / -xvzf /lua-openresty-memcached.tar.gz
	cd /lua-resty-memcached-${VER_OPENRESTY_MEMCACHED} \
	&& make \
	&& make install

# OpenResty Mysql
# ##############################################################################
dep-lua-openresty-mysql:
	curl -sLo /lua-openresty-mysql.tar.gz https://github.com/openresty/lua-resty-mysql/archive/v${VER_OPENRESTY_MYSQL}.tar.gz
	tar -C / -xvzf /lua-openresty-mysql.tar.gz
	cd /lua-resty-mysql-${VER_OPENRESTY_MYSQL} \
	&& make \
	&& make install

# OpenResty Redis
# ##############################################################################
dep-lua-openresty-redis:
	curl -sLo /lua-openresty-redis.tar.gz https://github.com/openresty/lua-resty-redis/archive/v${VER_OPENRESTY_REDIS}.tar.gz
	tar -C / -xvzf /lua-openresty-redis.tar.gz
	cd /lua-resty-redis-${VER_OPENRESTY_REDIS} \
	&& make \
	&& make install

# OpenResty Shell
# ##############################################################################
dep-lua-openresty-shell:
	curl -sLo /lua-openresty-shell.tar.gz https://github.com/openresty/lua-resty-shell/archive/v${VER_OPENRESTY_SHELL}.tar.gz
	tar -C / -xvzf /lua-openresty-shell.tar.gz
	cd /lua-resty-shell-${VER_OPENRESTY_SHELL} \
	&& make \
	&& make install

# OpenResty Tablepool
# ##############################################################################
dep-lua-openresty-tablepool:
	curl -sLo /lua-tablepool.tar.gz https://github.com/openresty/lua-tablepool/archive/refs/tags/v${VER_OPENRESTY_TABLEPOOL}.tar.gz
	tar -C / -xvzf /lua-tablepool.tar.gz
	cd /lua-tablepool-${VER_OPENRESTY_TABLEPOOL} \
	&& make \
	&& make install

# OpenResty Signal
# ##############################################################################
dep-lua-openresty-signal:
	curl -sLo /lua-openresty-signal.tar.gz https://github.com/openresty/lua-resty-signal/archive/refs/tags/v${VER_OPENRESTY_SIGNAL}.tar.gz
	tar -C / -xvzf /lua-openresty-signal.tar.gz
	cd /lua-resty-signal-${VER_OPENRESTY_SIGNAL} \
	&& make \
	&& make install \
	&& install -d /usr/local/lib/lua/5.4 \
	&& install /usr/local/share/lua/5.4/librestysignal.so /usr/local/lib/lua/5.4/librestysignal.so

# OpenResty Upstream Healthcheck
# ##############################################################################
dep-lua-resty-upstream-healthcheck:
	curl -sLo /lua-resty-upstream-healthcheck.tar.gz https://github.com/openresty/lua-resty-upstream-healthcheck/archive/v${VER_OPENRESTY_HEALTHCHECK}.tar.gz
	tar -C / -xvzf /lua-resty-upstream-healthcheck.tar.gz
	cd /lua-resty-upstream-healthcheck-${VER_OPENRESTY_HEALTHCHECK} \
	&& make \
	&& make install

# OpenResty Websocket
# ##############################################################################
dep-lua-openresty-websocket:
	curl -sLo /lua-openresty-websocket.tar.gz https://github.com/openresty/lua-resty-websocket/archive/v${VER_OPENRESTY_WEBSOCKET}.tar.gz
	tar -C / -xvzf /lua-openresty-websocket.tar.gz
	cd /lua-resty-websocket-${VER_OPENRESTY_WEBSOCKET} \
	&& make \
	&& make install

# OpenResty Nginx Misc
# ##############################################################################
dep-lua-openresty-misc:
	curl -Lo /lua-openresty-misc.tar.gz https://github.com/openresty/set-misc-nginx-module/archive/v${VER_OPENRESTY_MISC}.tar.gz
	tar -C / -xvzf /lua-openresty-misc.tar.gz

# LUA Upstream
# ##############################################################################
dep-lua-upstream-nginx-module:
	curl -sLo /lua-upstream-nginx-module.tar.gz https://github.com/openresty/lua-upstream-nginx-module/archive/v${VER_LUA_UPSTREAM}.tar.gz
	tar -C / -xvzf /lua-upstream-nginx-module.tar.gz

# Prometheus
# ##############################################################################
dep-nginx-lua-prometheus:
	curl -sLo /nginx-lua-prometheus.tar.gz https://github.com/knyar/nginx-lua-prometheus/archive/${VER_PROMETHEUS}.tar.gz
	tar -C / -xvzf /nginx-lua-prometheus.tar.gz
	mv /nginx-lua-prometheus-${VER_PROMETHEUS}/*.lua ${LUA_LIB_DIR}/

# OpenResty Stream Lua
# ##############################################################################
dep-stream-lua-nginx-module:
	curl -sLo /stream-lua-nginx-module.zip https://github.com/openresty/stream-lua-nginx-module/archive/${VER_OPENRESTY_STREAMLUA}.zip
	unzip -d / /stream-lua-nginx-module.zip

# ##############################################################################
# LUAROCKS
# ##############################################################################

luarocks:
	curl -sLo /luarocks.tar.gz https://luarocks.org/releases/luarocks-${VER_LUAROCKS}.tar.gz
	tar -C / -xzvf /luarocks.tar.gz
	cd /luarocks-${VER_LUAROCKS}; \
	./configure \
	&& make \
	&& make install

################################################################################
##@ COMPILE LUA
################################################################################

lua-src:
	curl -sLo /luasrc.tar.gz http://www.lua.org/ftp/lua-${VER_LUA}.tar.gz
	tar -C / -xzvf /luasrc.tar.gz
	cd /lua-$${VER_LUA}; \
	sed -i "s/DLUA_COMPAT_5_3/DLUA_COMPAT_5_1/" src/Makefile \
	&& sed -i "s/DLUA_COMPAT_5_2/DLUA_COMPAT_5_1/" src/Makefile \
	&& make linux test \
	&& make install \
	&& cp /lua-$${VER_LUA}/src/*.h /usr/include/
