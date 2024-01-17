#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2023 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

EXTENDED_IMAGE=YES
NPROC := $(shell nproc)

# TODO: Find a better way to fallback when openresty is behind the nginx latest
# version and no patch is available.
FALLBACK_VER_NGINX=1.23.0

# ##############################################################################
# CORE
# ##############################################################################

openresty-patches:
	mkdir -p /nginx-${VER_NGINX}/patches
	git clone https://github.com/openresty/openresty.git; \
	PATCH_VER=${VER_NGINX}; \
	if [ "$(ls -1 openresty/patches/nginx-${VER_NGINX}-*.patch 2>/dev/null)" = "" ]; then \
		PATCH_VER=${FALLBACK_VER_NGINX}; \
	fi; \
	for patch_file in openresty/patches/nginx-$${PATCH_VER}-*.patch; do \
		echo "copying openresty patch $${patch_file}"; \
		cp "$${patch_file}" /nginx-${VER_NGINX}/patches/; \
	done; \
	for patch_file in /patches/*.patch; do \
		echo "overriding openresty patch $${patch_file}"; \
		cp "$${patch_file}" /nginx-${VER_NGINX}/patches/; \
	done; \
	cd /nginx-${VER_NGINX}; \
	for patch_file in patches/*.patch; do \
		echo "applying openresty patch $${patch_file}"; \
		patch -p1 < "$${patch_file}"; \
	done; \

core:
# NGINX
# ##############################################################################
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published packaging sources
	curl -sLo /nginx.tar.gz https://nginx.org/download/nginx-${VER_NGINX}.tar.gz
	tar -C / -xvzf /nginx.tar.gz
	mkdir -p /var/cache/nginx/client_temp \
		/var/cache/nginx/proxy_temp \
		/var/cache/nginx/fastcgi_temp \
		/var/cache/nginx/uwsgi_temp \
		/var/cache/nginx/scgi_temp
	make openresty-patches
	cd /nginx-${VER_NGINX}; \
	./configure ${NGINX_BUILD_CONFIG} --with-cc-opt="$(NGX_CFLAGS)" --with-ld-opt="$(NGX_LDOPT)" --with-debug \
	&& $(MAKE) build \
	&& mv objs/nginx objs/nginx-debug \
	&& ./configure ${NGINX_BUILD_CONFIG} --with-cc-opt="$(NGX_CFLAGS)" --with-ld-opt="$(NGX_LDOPT)" \
	&& $(MAKE) build \
	&& $(MAKE) modules \
	&& install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
	&& $(MAKE) install

# ##############################################################################
# DEPENDENCIES
# ##############################################################################

deps: dep-ngx_devel_kit dep-njs dep-geoip2 dep-luajit dep-lua-nginx dep-lua-resty-core dep-lua-resty-lrucache
ifeq ($(EXTENDED_IMAGE), YES)
	$(MAKE) dep-headers-more-nginx-module dep-lua-resty-cookie dep-lua-openresty-dns \
		dep-lua-openresty-memcached dep-lua-openresty-mysql dep-lua-openresty-redis \
		dep-lua-openresty-shell dep-lua-openresty-tablepool dep-lua-openresty-signal \
		dep-lua-resty-upstream-healthcheck dep-lua-openresty-websocket \
		dep-lua-upstream-nginx-module dep-nginx-lua-prometheus dep-stream-lua-nginx-module \
		dep-lua-openresty-misc dep-lua-resty-limit-traffic dep-lua-resty-upload \
		dep-lua-resty-lock dep-lua-resty-balancer dep-lua-resty-string
endif

# NGX Devel Kit
# ##############################################################################
dep-ngx_devel_kit:
	curl -sLo /ngx_devel_kit.tar.gz https://github.com/vision5/ngx_devel_kit/archive/v${VER_NGX_DEVEL_KIT}.tar.gz
	tar -C / -xvzf /ngx_devel_kit.tar.gz

# njs
# ##############################################################################
dep-njs:
	curl -sLo /njs.tar.gz https://github.com/nginx/njs/archive/refs/tags/${VER_NJS}.tar.gz
	tar -C / -xvzf /njs.tar.gz

# geoip2
# ##############################################################################
dep-geoip2:
	mkdir -p /usr/lib64
	curl -sLo /geoip2.tar.gz https://github.com/leev/ngx_http_geoip2_module/archive/refs/tags/${VER_GEOIP}.tar.gz
	tar -C / -xvzf /geoip2.tar.gz

# OpenResty LUAJIT2
# ##############################################################################
dep-luajit:
	curl -sLo /luajit.tar.gz https://github.com/openresty/luajit2/archive/v${VER_LUAJIT}.tar.gz
	tar -C / -xvzf /luajit.tar.gz
	cd /luajit2-${VER_LUAJIT} \
	&& $(MAKE) \
	&& $(MAKE) install

# Lua Nginx Module
# ##############################################################################
dep-lua-nginx:
	curl -sLo /lua-nginx.tar.gz https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz
	tar -C / -xvzf /lua-nginx.tar.gz

# LUA Resty Core
# ##############################################################################
dep-lua-resty-core:
	curl -sLo /lua-resty-core.tar.gz https://github.com/openresty/lua-resty-core/archive/v${VER_LUA_RESTY_CORE}.tar.gz
	tar -C / -xvzf /lua-resty-core.tar.gz
	cd /lua-resty-core-${VER_LUA_RESTY_CORE} \
	&& $(MAKE) \
	&& $(MAKE) install

# LUA Resty LRUCache
# ##############################################################################
dep-lua-resty-lrucache:
	curl -sLo /lua-resty-lrucache.tar.gz https://github.com/openresty/lua-resty-lrucache/archive/v${VER_LUA_RESTY_LRUCACHE}.tar.gz
	tar -C / -xvzf /lua-resty-lrucache.tar.gz
	cd /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
	&& $(MAKE) \
	&& $(MAKE) install

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
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Dns
# ##############################################################################
dep-lua-openresty-dns:
	curl -sLo /lua-openresty-dns.tar.gz https://github.com/openresty/lua-resty-dns/archive/v${VER_OPENRESTY_DNS}.tar.gz
	tar -C / -xvzf /lua-openresty-dns.tar.gz
	cd /lua-resty-dns-${VER_OPENRESTY_DNS} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Memcached
# ##############################################################################
dep-lua-openresty-memcached:
	curl -sLo /lua-openresty-memcached.tar.gz https://github.com/openresty/lua-resty-memcached/archive/v${VER_OPENRESTY_MEMCACHED}.tar.gz
	tar -C / -xvzf /lua-openresty-memcached.tar.gz
	cd /lua-resty-memcached-${VER_OPENRESTY_MEMCACHED} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Mysql
# ##############################################################################
dep-lua-openresty-mysql:
	curl -sLo /lua-openresty-mysql.tar.gz https://github.com/openresty/lua-resty-mysql/archive/v${VER_OPENRESTY_MYSQL}.tar.gz
	tar -C / -xvzf /lua-openresty-mysql.tar.gz
	cd /lua-resty-mysql-${VER_OPENRESTY_MYSQL} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Redis
# ##############################################################################
dep-lua-openresty-redis:
	curl -sLo /lua-openresty-redis.tar.gz https://github.com/openresty/lua-resty-redis/archive/v${VER_OPENRESTY_REDIS}.tar.gz
	tar -C / -xvzf /lua-openresty-redis.tar.gz
	cd /lua-resty-redis-${VER_OPENRESTY_REDIS} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Shell
# ##############################################################################
dep-lua-openresty-shell:
	curl -sLo /lua-openresty-shell.tar.gz https://github.com/openresty/lua-resty-shell/archive/v${VER_OPENRESTY_SHELL}.tar.gz
	tar -C / -xvzf /lua-openresty-shell.tar.gz
	cd /lua-resty-shell-${VER_OPENRESTY_SHELL} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Tablepool
# ##############################################################################
dep-lua-openresty-tablepool:
	curl -sLo /lua-tablepool.tar.gz https://github.com/openresty/lua-tablepool/archive/refs/tags/v${VER_OPENRESTY_TABLEPOOL}.tar.gz
	tar -C / -xvzf /lua-tablepool.tar.gz
	cd /lua-tablepool-${VER_OPENRESTY_TABLEPOOL} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Signal
# ##############################################################################
dep-lua-openresty-signal:
	curl -sLo /lua-openresty-signal.tar.gz https://github.com/openresty/lua-resty-signal/archive/refs/tags/v${VER_OPENRESTY_SIGNAL}.tar.gz
	tar -C / -xvzf /lua-openresty-signal.tar.gz
	cd /lua-resty-signal-${VER_OPENRESTY_SIGNAL} \
	&& $(MAKE) \
	&& $(MAKE) install \
	&& install -d /usr/local/lib/lua/5.1 \
	&& install /usr/local/share/lua/5.1/librestysignal.so /usr/local/lib/lua/5.1/librestysignal.so

# OpenResty Upstream Healthcheck
# ##############################################################################
dep-lua-resty-upstream-healthcheck:
	curl -sLo /lua-resty-upstream-healthcheck.tar.gz https://github.com/openresty/lua-resty-upstream-healthcheck/archive/refs/tags/v${VER_OPENRESTY_HEALTHCHECK}.tar.gz
	tar -C / -xvzf /lua-resty-upstream-healthcheck.tar.gz
	cd /lua-resty-upstream-healthcheck-${VER_OPENRESTY_HEALTHCHECK} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Websocket
# ##############################################################################
dep-lua-openresty-websocket:
	curl -sLo /lua-openresty-websocket.tar.gz https://github.com/openresty/lua-resty-websocket/archive/v${VER_OPENRESTY_WEBSOCKET}.tar.gz
	tar -C / -xvzf /lua-openresty-websocket.tar.gz
	cd /lua-resty-websocket-${VER_OPENRESTY_WEBSOCKET} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Nginx Misc
# ##############################################################################
dep-lua-openresty-misc:
	curl -Lo /lua-openresty-misc.tar.gz https://github.com/openresty/set-misc-nginx-module/archive/v${VER_MISC_NGINX}.tar.gz
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
	curl -sLo /stream-lua-nginx-module.zip https://github.com/openresty/stream-lua-nginx-module/archive/v${VER_OPENRESTY_STREAMLUA}.zip
	unzip -d / /stream-lua-nginx-module.zip

# OpenResty Limit Traffic
# ##############################################################################
dep-lua-resty-limit-traffic:
	curl -sLo /lua-resty-limit-traffic.zip https://github.com/openresty/lua-resty-limit-traffic/archive/v${VER_OPENRESTY_LIMITTRAFFIC}.zip
	unzip -d / /lua-resty-limit-traffic.zip
	cd /lua-resty-limit-traffic-${VER_OPENRESTY_LIMITTRAFFIC} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Upload
# ##############################################################################
dep-lua-resty-upload:
	curl -sLo /lua-resty-upload.zip https://github.com/openresty/lua-resty-upload/archive/v${VER_OPENRESTY_UPLOAD}.zip
	unzip -d / /lua-resty-upload.zip
	cd /lua-resty-upload-${VER_OPENRESTY_UPLOAD} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Lock
# ##############################################################################
dep-lua-resty-lock:
	curl -sLo /lua-resty-lock.zip https://github.com/openresty/lua-resty-lock/archive/v${VER_OPENRESTY_LOCK}.zip
	unzip -d / /lua-resty-lock.zip
	cd /lua-resty-lock-${VER_OPENRESTY_LOCK} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Balancer
# ##############################################################################
dep-lua-resty-balancer:
	curl -sLo /lua-resty-balancer.zip https://github.com/openresty/lua-resty-balancer/archive/v${VER_OPENRESTY_BALANCER}.zip
	unzip -d / /lua-resty-balancer.zip
	cd /lua-resty-balancer-${VER_OPENRESTY_BALANCER} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty String
# ##############################################################################
dep-lua-resty-string:
	curl -sLo /lua-resty-string.zip https://github.com/openresty/lua-resty-string/archive/v${VER_OPENRESTY_STRING}.zip
	unzip -d / /lua-resty-string.zip
	cd /lua-resty-string-${VER_OPENRESTY_STRING} \
	&& $(MAKE) \
	&& $(MAKE) install

# ##############################################################################
# LUAROCKS
# ##############################################################################

luarocks:
	curl -sLo /luarocks.tar.gz https://luarocks.org/releases/luarocks-${VER_LUAROCKS}.tar.gz
	tar -C / -xzvf /luarocks.tar.gz
	cd /luarocks-${VER_LUAROCKS}; \
	./configure \
	&& $(MAKE) \
	&& $(MAKE) install
