#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2025 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

EXTENDED_IMAGE=YES
NPROC := $(shell nproc)

# Load SHA256 checksums and version variables from .env.dist
# These are populated by bin/generate-deps-env.py and verified at download time
-include .env.dist

# Build-time guard: fail early if any SHA256 checksums are missing.
# All checksums must be computed before building production images.
CHECK_UNPINNED := $(shell grep -c 'RECOMPUTE_REQUIRED' .env.dist 2>/dev/null || echo 0)
ifneq ($(CHECK_UNPINNED), 0)
$(warning WARNING: $(CHECK_UNPINNED) SHA256 checksum(s) marked RECOMPUTE_REQUIRED in .env.dist)
$(warning Run bin/generate-deps-env.py to compute missing hashes before production builds.)
endif

# Secure download function: downloads a file and verifies its SHA256 checksum.
# Usage: $(call secure_download,<url>,<output_file>,<expected_sha256>)
# If the expected SHA256 is empty, the download proceeds with a warning.
# If the SHA256 does not match, the build FAILS immediately.
# Ref: SLSA Level 2 - verified source integrity
# Ref: Cyber Resilience Act Article 47 - supply chain integrity
define secure_download
	@echo "=== Secure Download: $(1) ===" && \
	curl -sfLo $(2) "$(1)" && \
	ACTUAL_SHA256=$$(sha256sum $(2) | awk '{print $$1}') && \
	if [ -n "$(3)" ] && [ "$(3)" != "RECOMPUTE_REQUIRED" ]; then \
		if [ "$$ACTUAL_SHA256" != "$(3)" ]; then \
			echo "FATAL: SHA256 checksum mismatch for $(2)!" && \
			echo "  Expected: $(3)" && \
			echo "  Actual:   $$ACTUAL_SHA256" && \
			echo "  This may indicate a supply chain attack or version drift." && \
			echo "  Update the SHA256 in src/.env.dist if this is a legitimate version change." && \
			rm -f $(2) && exit 1; \
		else \
			echo "  SHA256 verified OK: $$ACTUAL_SHA256"; \
		fi; \
	else \
		echo "  WARNING: No checksum pinned - SHA256: $$ACTUAL_SHA256"; \
		echo "  Pin this hash in src/.env.dist to prevent supply chain attacks."; \
	fi
endef

# TODO: Find a better way to fallback when openresty is behind the nginx latest
# version and no patch is available.
# Ref: https://github.com/openresty/openresty/tree/master/patches/nginx
FALLBACK_VER_NGINX=1.27.1

# ##############################################################################
# CORE
# ##############################################################################

# DISABLED PATCHES
#
# >>> /nginx-1.29.0/patches/nginx-1.27.1-stream_proxy_protocol_v2.patch <<<
#     src/mail/ngx_mail_proxy_module.c: In function 'ngx_mail_proxy_send_proxy_protocol':
#     src/mail/ngx_mail_proxy_module.c:906:9: error: too few arguments to function 'ngx_proxy_protocol_write'
#       906 |     p = ngx_proxy_protocol_write(s->connection, buf,
#           |         ^~~~~~~~~~~~~~~~~~~~~~~~
#     In file included from src/core/ngx_core.h:98,
#                      from src/mail/ngx_mail_proxy_module.c:9:
#     src/core/ngx_proxy_protocol.h:31:9: note: declared here
#        31 | u_char *ngx_proxy_protocol_write(ngx_connection_t *c, u_char *buf,
#           |         ^~~~~~~~~~~~~~~~~~~~~~~~
#     make[2]: *** [objs/Makefile:2229: objs/src/mail/ngx_mail_proxy_module.o] Error 1
SKIPPED_PATCHES=" \
patches/nginx-1.27.1-stream_proxy_protocol_v2.patch \
"
openresty-patches:
	mkdir -p /nginx-${VER_NGINX}/patches
	git clone https://github.com/openresty/openresty.git; \
	PATCH_VER=${VER_NGINX}; \
	if [ "$(ls -1 openresty/patches/nginx/${VER_NGINX}/nginx-${VER_NGINX}-*.patch 2>/dev/null)" = "" ]; then \
		PATCH_VER=${FALLBACK_VER_NGINX}; \
	fi; \
	for patch_file in openresty/patches/nginx/$${PATCH_VER}/nginx-$${PATCH_VER}-*.patch; do \
		echo "copying openresty patch $${patch_file}"; \
		cp "$${patch_file}" /nginx-${VER_NGINX}/patches/; \
	done; \
	for patch_file in /patches/*.patch; do \
		echo "overriding openresty patch $${patch_file}"; \
		cp "$${patch_file}" /nginx-${VER_NGINX}/patches/; \
	done; \
	cd /nginx-${VER_NGINX}; \
	for patch_file in patches/*.patch; do \
		if [ "$$(echo "$(SKIPPED_PATCHES)" | grep -qw "$${patch_file}"; echo $$?)" -eq 0 ]; then \
			echo "skipping openresty patch $${patch_file}"; \
		else \
			echo "applying openresty patch $${patch_file}"; \
			patch -p1 < "$${patch_file}"; \
		fi; \
	done; \

core:
# NGINX
# ##############################################################################
	$(call secure_download,https://nginx.org/download/nginx-${VER_NGINX}.tar.gz,/nginx.tar.gz,${SHA256_NGINX})
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
	$(call secure_download,https://github.com/vision5/ngx_devel_kit/archive/v${VER_NGX_DEVEL_KIT}.tar.gz,/ngx_devel_kit.tar.gz,${SHA256_NGX_DEVEL_KIT})
	tar -C / -xvzf /ngx_devel_kit.tar.gz

# njs
# ##############################################################################
dep-njs:
	$(call secure_download,https://github.com/nginx/njs/archive/refs/tags/${VER_NJS}.tar.gz,/njs.tar.gz,${SHA256_NJS})
	tar -C / -xvzf /njs.tar.gz

# geoip2
# ##############################################################################
dep-geoip2:
	mkdir -p /usr/lib64
	$(call secure_download,https://github.com/leev/ngx_http_geoip2_module/archive/refs/tags/${VER_GEOIP}.tar.gz,/geoip2.tar.gz,${SHA256_GEOIP})
	tar -C / -xvzf /geoip2.tar.gz

# OpenResty LUAJIT2
# ##############################################################################
dep-luajit:
	$(call secure_download,https://github.com/openresty/luajit2/archive/v${VER_LUAJIT}.tar.gz,/luajit.tar.gz,${SHA256_LUAJIT})
	tar -C / -xvzf /luajit.tar.gz
	cd /luajit2-${VER_LUAJIT} \
	&& $(MAKE) \
	&& $(MAKE) install

# Lua Nginx Module
# ##############################################################################
dep-lua-nginx:
	$(call secure_download,https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz,/lua-nginx.tar.gz,${SHA256_LUA_NGINX_MODULE})
	tar -C / -xvzf /lua-nginx.tar.gz

# LUA Resty Core
# ##############################################################################
dep-lua-resty-core:
	$(call secure_download,https://github.com/openresty/lua-resty-core/archive/v${VER_LUA_RESTY_CORE}.tar.gz,/lua-resty-core.tar.gz,${SHA256_LUA_RESTY_CORE})
	tar -C / -xvzf /lua-resty-core.tar.gz
	cd /lua-resty-core-${VER_LUA_RESTY_CORE} \
	&& $(MAKE) \
	&& $(MAKE) install

# LUA Resty LRUCache
# ##############################################################################
dep-lua-resty-lrucache:
	$(call secure_download,https://github.com/openresty/lua-resty-lrucache/archive/v${VER_LUA_RESTY_LRUCACHE}.tar.gz,/lua-resty-lrucache.tar.gz,${SHA256_LUA_RESTY_LRUCACHE})
	tar -C / -xvzf /lua-resty-lrucache.tar.gz
	cd /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Headers
# ##############################################################################
dep-headers-more-nginx-module:
	$(call secure_download,https://github.com/openresty/headers-more-nginx-module/archive/v${VER_OPENRESTY_HEADERS}.tar.gz,/headers-more-nginx-module.tar.gz,${SHA256_OPENRESTY_HEADERS})
	tar -C / -xvzf /headers-more-nginx-module.tar.gz

# Cloudflare Cookie
# ##############################################################################
dep-lua-resty-cookie:
	$(call secure_download,https://github.com/cloudflare/lua-resty-cookie/archive/${VER_CLOUDFLARE_COOKIE}.tar.gz,/lua-resty-cookie.tar.gz,${SHA256_CLOUDFLARE_COOKIE})
	tar -C / -xvzf /lua-resty-cookie.tar.gz
	cd /lua-resty-cookie-${VER_CLOUDFLARE_COOKIE} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Dns
# ##############################################################################
dep-lua-openresty-dns:
	$(call secure_download,https://github.com/openresty/lua-resty-dns/archive/v${VER_OPENRESTY_DNS}.tar.gz,/lua-openresty-dns.tar.gz,${SHA256_OPENRESTY_DNS})
	tar -C / -xvzf /lua-openresty-dns.tar.gz
	cd /lua-resty-dns-${VER_OPENRESTY_DNS} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Memcached
# ##############################################################################
dep-lua-openresty-memcached:
	$(call secure_download,https://github.com/openresty/lua-resty-memcached/archive/v${VER_OPENRESTY_MEMCACHED}.tar.gz,/lua-openresty-memcached.tar.gz,${SHA256_OPENRESTY_MEMCACHED})
	tar -C / -xvzf /lua-openresty-memcached.tar.gz
	cd /lua-resty-memcached-${VER_OPENRESTY_MEMCACHED} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Mysql
# ##############################################################################
dep-lua-openresty-mysql:
	$(call secure_download,https://github.com/openresty/lua-resty-mysql/archive/v${VER_OPENRESTY_MYSQL}.tar.gz,/lua-openresty-mysql.tar.gz,${SHA256_OPENRESTY_MYSQL})
	tar -C / -xvzf /lua-openresty-mysql.tar.gz
	cd /lua-resty-mysql-${VER_OPENRESTY_MYSQL} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Redis
# ##############################################################################
dep-lua-openresty-redis:
	$(call secure_download,https://github.com/openresty/lua-resty-redis/archive/v${VER_OPENRESTY_REDIS}.tar.gz,/lua-openresty-redis.tar.gz,${SHA256_OPENRESTY_REDIS})
	tar -C / -xvzf /lua-openresty-redis.tar.gz
	cd /lua-resty-redis-${VER_OPENRESTY_REDIS} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Shell
# ##############################################################################
dep-lua-openresty-shell:
	$(call secure_download,https://github.com/openresty/lua-resty-shell/archive/v${VER_OPENRESTY_SHELL}.tar.gz,/lua-openresty-shell.tar.gz,${SHA256_OPENRESTY_SHELL})
	tar -C / -xvzf /lua-openresty-shell.tar.gz
	cd /lua-resty-shell-${VER_OPENRESTY_SHELL} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Tablepool
# ##############################################################################
dep-lua-openresty-tablepool:
	$(call secure_download,https://github.com/openresty/lua-tablepool/archive/refs/tags/v${VER_OPENRESTY_TABLEPOOL}.tar.gz,/lua-tablepool.tar.gz,${SHA256_OPENRESTY_TABLEPOOL})
	tar -C / -xvzf /lua-tablepool.tar.gz
	cd /lua-tablepool-${VER_OPENRESTY_TABLEPOOL} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Signal
# ##############################################################################
dep-lua-openresty-signal:
	$(call secure_download,https://github.com/openresty/lua-resty-signal/archive/refs/tags/v${VER_OPENRESTY_SIGNAL}.tar.gz,/lua-openresty-signal.tar.gz,${SHA256_OPENRESTY_SIGNAL})
	tar -C / -xvzf /lua-openresty-signal.tar.gz
	cd /lua-resty-signal-${VER_OPENRESTY_SIGNAL} \
	&& $(MAKE) \
	&& $(MAKE) install \
	&& install -d /usr/local/lib/lua/5.1 \
	&& install /usr/local/share/lua/5.1/librestysignal.so /usr/local/lib/lua/5.1/librestysignal.so

# OpenResty Upstream Healthcheck
# ##############################################################################
dep-lua-resty-upstream-healthcheck:
	$(call secure_download,https://github.com/openresty/lua-resty-upstream-healthcheck/archive/refs/tags/v${VER_OPENRESTY_HEALTHCHECK}.tar.gz,/lua-resty-upstream-healthcheck.tar.gz,${SHA256_OPENRESTY_HEALTHCHECK})
	tar -C / -xvzf /lua-resty-upstream-healthcheck.tar.gz
	cd /lua-resty-upstream-healthcheck-${VER_OPENRESTY_HEALTHCHECK} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Websocket
# ##############################################################################
dep-lua-openresty-websocket:
	$(call secure_download,https://github.com/openresty/lua-resty-websocket/archive/v${VER_OPENRESTY_WEBSOCKET}.tar.gz,/lua-openresty-websocket.tar.gz,${SHA256_OPENRESTY_WEBSOCKET})
	tar -C / -xvzf /lua-openresty-websocket.tar.gz
	cd /lua-resty-websocket-${VER_OPENRESTY_WEBSOCKET} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Nginx Misc
# ##############################################################################
dep-lua-openresty-misc:
	$(call secure_download,https://github.com/openresty/set-misc-nginx-module/archive/v${VER_MISC_NGINX}.tar.gz,/lua-openresty-misc.tar.gz,${SHA256_MISC_NGINX})
	tar -C / -xvzf /lua-openresty-misc.tar.gz

# LUA Upstream
# ##############################################################################
dep-lua-upstream-nginx-module:
	$(call secure_download,https://github.com/openresty/lua-upstream-nginx-module/archive/v${VER_LUA_UPSTREAM}.tar.gz,/lua-upstream-nginx-module.tar.gz,${SHA256_LUA_UPSTREAM})
	tar -C / -xvzf /lua-upstream-nginx-module.tar.gz

# Prometheus
# ##############################################################################
dep-nginx-lua-prometheus:
	$(call secure_download,https://github.com/knyar/nginx-lua-prometheus/archive/${VER_PROMETHEUS}.tar.gz,/nginx-lua-prometheus.tar.gz,${SHA256_PROMETHEUS})
	tar -C / -xvzf /nginx-lua-prometheus.tar.gz
	mv /nginx-lua-prometheus-${VER_PROMETHEUS}/*.lua ${LUA_LIB_DIR}/

# OpenResty Stream Lua
# ##############################################################################
dep-stream-lua-nginx-module:
	$(call secure_download,https://github.com/openresty/stream-lua-nginx-module/archive/${VER_OPENRESTY_STREAMLUA}.tar.gz,/stream-lua-nginx-module.tar.gz,${SHA256_OPENRESTY_STREAMLUA})
	tar -C / -xvzf /stream-lua-nginx-module.tar.gz

# OpenResty Limit Traffic
# ##############################################################################
dep-lua-resty-limit-traffic:
	$(call secure_download,https://github.com/openresty/lua-resty-limit-traffic/archive/v${VER_OPENRESTY_LIMITTRAFFIC}.tar.gz,/lua-resty-limit-traffic.tar.gz,${SHA256_OPENRESTY_LIMITTRAFFIC})
	tar -C / -xvzf /lua-resty-limit-traffic.tar.gz
	cd /lua-resty-limit-traffic-${VER_OPENRESTY_LIMITTRAFFIC} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Upload
# ##############################################################################
dep-lua-resty-upload:
	$(call secure_download,https://github.com/openresty/lua-resty-upload/archive/v${VER_OPENRESTY_UPLOAD}.tar.gz,/lua-resty-upload.tar.gz,${SHA256_OPENRESTY_UPLOAD})
	tar -C / -xvzf /lua-resty-upload.tar.gz
	cd /lua-resty-upload-${VER_OPENRESTY_UPLOAD} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Lock
# ##############################################################################
dep-lua-resty-lock:
	$(call secure_download,https://github.com/openresty/lua-resty-lock/archive/v${VER_OPENRESTY_LOCK}.tar.gz,/lua-resty-lock.tar.gz,${SHA256_OPENRESTY_LOCK})
	tar -C / -xvzf /lua-resty-lock.tar.gz
	cd /lua-resty-lock-${VER_OPENRESTY_LOCK} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty Balancer
# ##############################################################################
dep-lua-resty-balancer:
	$(call secure_download,https://github.com/openresty/lua-resty-balancer/archive/v${VER_OPENRESTY_BALANCER}.tar.gz,/lua-resty-balancer.tar.gz,${SHA256_OPENRESTY_BALANCER})
	tar -C / -xvzf /lua-resty-balancer.tar.gz
	cd /lua-resty-balancer-${VER_OPENRESTY_BALANCER} \
	&& $(MAKE) \
	&& $(MAKE) install

# OpenResty String
# ##############################################################################
dep-lua-resty-string:
	$(call secure_download,https://github.com/openresty/lua-resty-string/archive/v${VER_OPENRESTY_STRING}.tar.gz,/lua-resty-string.tar.gz,${SHA256_OPENRESTY_STRING})
	tar -C / -xvzf /lua-resty-string.tar.gz
	cd /lua-resty-string-${VER_OPENRESTY_STRING} \
	&& $(MAKE) \
	&& $(MAKE) install

# ##############################################################################
# LUAROCKS
# ##############################################################################

luarocks:
	$(call secure_download,https://luarocks.org/releases/luarocks-${VER_LUAROCKS}.tar.gz,/luarocks.tar.gz,${SHA256_LUAROCKS})
	tar -C / -xzvf /luarocks.tar.gz
	cd /luarocks-${VER_LUAROCKS}; \
	./configure \
	&& $(MAKE) \
	&& $(MAKE) install
