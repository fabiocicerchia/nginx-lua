#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2020 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

NPROC := $(shell nproc)

# ##############################################################################
# CORE
# ##############################################################################

core:
# NGINX
# ##############################################################################
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published packaging sources
	curl -Lo /nginx.tar.gz https://nginx.org/download/nginx-${VER_NGINX}.tar.gz
	tar -C / -xvzf /nginx.tar.gz
	mkdir -p /var/cache/nginx/client_temp \
		/var/cache/nginx/proxy_temp \
		/var/cache/nginx/fastcgi_temp \
		/var/cache/nginx/uwsgi_temp \
		/var/cache/nginx/scgi_temp
	cd /nginx-${VER_NGINX} \
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

deps: dep-ngx_devel_kit dep-luajit dep-lua-nginx dep-lua-resty-core dep-lua-resty-lrucache dep-headers-more-nginx-module dep-lua-resty-cookie dep-lua-openresty-dns dep-lua-openresty-memcached dep-lua-openresty-mysql dep-lua-openresty-redis dep-lua-openresty-shell dep-lua-resty-upstream-healthcheck dep-lua-openresty-websocket dep-lua-upstream-nginx-module dep-nginx-lua-prometheus dep-stream-lua-nginx-module

# NGX Devel Kit
# ##############################################################################
dep-ngx_devel_kit:
	curl -Lo /ngx_devel_kit.tar.gz https://github.com/vision5/ngx_devel_kit/archive/v${VER_NGX_DEVEL_KIT}.tar.gz
	tar -C / -xvzf /ngx_devel_kit.tar.gz

# OpenResty LUAJIT2
# ##############################################################################
dep-luajit:
	curl -Lo /luajit.tar.gz https://github.com/openresty/luajit2/archive/v${VER_LUAJIT}.tar.gz
	tar -C / -xvzf /luajit.tar.gz
	cd /luajit2-${VER_LUAJIT} \
	&& make \
	&& make install

# Lua Nginx Module
# ##############################################################################
dep-lua-nginx:
	curl -Lo /lua-nginx.tar.gz https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz
	tar -C / -xvzf /lua-nginx.tar.gz

# LUA Resty Core
# ##############################################################################
dep-lua-resty-core:
	curl -Lo /lua-resty-core.tar.gz https://github.com/openresty/lua-resty-core/archive/v${VER_LUA_RESTY_CORE}.tar.gz
	tar -C / -xvzf /lua-resty-core.tar.gz
	cd /lua-resty-core-${VER_LUA_RESTY_CORE} \
	&& make \
	&& make install

# LUA Resty LRUCache
# ##############################################################################
dep-lua-resty-lrucache:
	curl -Lo /lua-resty-lrucache.tar.gz https://github.com/openresty/lua-resty-lrucache/archive/v${VER_LUA_RESTY_LRUCACHE}.tar.gz
	tar -C / -xvzf /lua-resty-lrucache.tar.gz
	cd /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
	&& make \
	&& make install

# OpenResty Headers
# ##############################################################################
dep-headers-more-nginx-module:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /headers-more-nginx-module.zip https://github.com/openresty/headers-more-nginx-module/archive/${VER_OPENRESTY_HEADERS}.zip
	unzip -d / /headers-more-nginx-module.zip
endif

# Cloudflare Cookie
# ##############################################################################
dep-lua-resty-cookie:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /lua-resty-cookie.tar.gz https://github.com/cloudflare/lua-resty-cookie/archive/${VER_CLOUDFLARE_COOKIE}.tar.gz
	tar -C / -xvzf /lua-resty-cookie.tar.gz
	cd /lua-resty-cookie-${VER_CLOUDFLARE_COOKIE} \
	&& make
endif

# OpenResty Dns
# ##############################################################################
dep-lua-openresty-dns:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /lua-openresty-dns.tar.gz https://github.com/openresty/lua-resty-dns/archive/v${VER_OPENRESTY_DNS}.tar.gz
	tar -C / -xvzf /lua-openresty-dns.tar.gz
	cd /lua-resty-dns-${VER_OPENRESTY_DNS} \
	&& make \
	&& make install
endif

# OpenResty Memcached
# ##############################################################################
dep-lua-openresty-memcached:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /lua-openresty-memcached.tar.gz https://github.com/openresty/lua-resty-memcached/archive/v${VER_OPENRESTY_MEMCACHED}.tar.gz
	tar -C / -xvzf /lua-openresty-memcached.tar.gz
	cd /lua-resty-memcached-${VER_OPENRESTY_MEMCACHED} \
	&& make \
	&& make install
endif

# OpenResty Mysql
# ##############################################################################
dep-lua-openresty-mysql:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /lua-openresty-mysql.tar.gz https://github.com/openresty/lua-resty-mysql/archive/v${VER_OPENRESTY_MYSQL}.tar.gz
	tar -C / -xvzf /lua-openresty-mysql.tar.gz
	cd /lua-resty-mysql-${VER_OPENRESTY_MYSQL} \
	&& make \
	&& make install
endif

# OpenResty Redis
# ##############################################################################
dep-lua-openresty-redis:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /lua-openresty-redis.tar.gz https://github.com/openresty/lua-resty-redis/archive/v${VER_OPENRESTY_REDIS}.tar.gz
	tar -C / -xvzf /lua-openresty-redis.tar.gz
	cd /lua-resty-redis-${VER_OPENRESTY_REDIS} \
	&& make \
	&& make install
endif

# OpenResty Shell
# ##############################################################################
dep-lua-openresty-shell:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /lua-openresty-shell.tar.gz https://github.com/openresty/lua-resty-shell/archive/v${VER_OPENRESTY_SHELL}.tar.gz
	tar -C / -xvzf /lua-openresty-shell.tar.gz
	cd /lua-resty-shell-${VER_OPENRESTY_SHELL} \
	&& make \
	&& make install
endif

# OpenResty Upstream Healthcheck
# ##############################################################################
dep-lua-resty-upstream-healthcheck:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /lua-resty-upstream-healthcheck.tar.gz https://github.com/openresty/lua-resty-upstream-healthcheck/archive/v${VER_OPENRESTY_HEALTHCHECK}.tar.gz
	tar -C / -xvzf /lua-resty-upstream-healthcheck.tar.gz
	cd /lua-resty-upstream-healthcheck-${VER_OPENRESTY_HEALTHCHECK} \
	&& make \
	&& make install
endif

# OpenResty Websocket
# ##############################################################################
dep-lua-openresty-websocket:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /lua-openresty-websocket.tar.gz https://github.com/openresty/lua-resty-websocket/archive/v${VER_OPENRESTY_WEBSOCKET}.tar.gz
	tar -C / -xvzf /lua-openresty-websocket.tar.gz
	cd /lua-resty-websocket-${VER_OPENRESTY_WEBSOCKET} \
	&& make \
	&& make install
endif

# LUA Upstream
# ##############################################################################
dep-lua-upstream-nginx-module:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /lua-upstream-nginx-module.tar.gz https://github.com/openresty/lua-upstream-nginx-module/archive/v${VER_LUA_UPSTREAM}.tar.gz
	tar -C / -xvzf /lua-upstream-nginx-module.tar.gz
endif

# Prometheus
# ##############################################################################
dep-nginx-lua-prometheus:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /nginx-lua-prometheus.tar.gz https://github.com/knyar/nginx-lua-prometheus/archive/${VER_PROMETHEUS}.tar.gz
	tar -C / -xvzf /nginx-lua-prometheus.tar.gz
	mv /nginx-lua-prometheus-${VER_PROMETHEUS}/*.lua ${LUA_LIB_DIR}/
endif

# OpenResty Stream Lua
# ##############################################################################
dep-stream-lua-nginx-module:
ifeq ($(EXTENDED_IMAGE), 1)
	curl -Lo /stream-lua-nginx-module.zip https://github.com/openresty/stream-lua-nginx-module/archive/v${VER_OPENRESTY_STREAMLUA}.zip
	unzip -d / /stream-lua-nginx-module.zip
endif

# ##############################################################################
# LUAROCKS
# ##############################################################################

luarocks:
	curl -Lo /luarocks.tar.gz https://luarocks.org/releases/luarocks-${VER_LUAROCKS}.tar.gz
	tar -C / -xzvf /luarocks.tar.gz
	cd /luarocks-${VER_LUAROCKS}; \
	./configure \
	&& make \
	&& make install
