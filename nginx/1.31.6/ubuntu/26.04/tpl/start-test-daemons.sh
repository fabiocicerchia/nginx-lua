#!/bin/sh
# lua-resty-memcached/mysql/redis need a real server to talk to. Upstream's
# own CI gets this from a service container (Travis services:, or a sibling
# `docker run` in initializedb.sh) - neither is available to a `RUN` step
# inside our own `docker build` (no Docker-in-Docker here), so instead we
# start the equivalent native daemon directly in the build container: same
# real server, same real wire protocol, just not nested-Docker.
set -eu

# .env.dist is plain shell KEY=value syntax - source it directly for
# VER_OPENRESTY_MYSQL/VER_OPENRESTY_REDIS below, same as the Makefile does.
. ./.env.dist

# track_sizes: without it, memcached's `stats sizes` command reports
# "sizes_status disabled" instead of the numeric breakdown
# lua-resty-memcached's t/sanity.t expects.
memcached -d -u root -o track_sizes

# Second, TLS-enabled instance on its own port for t/tls.t, presenting a
# leaf cert signed by our own throwaway CA (not a single self-signed
# leaf): t/tls.t's strict-verification case expects OpenSSL error 19
# (self-signed cert *in the chain*, i.e. the untrusted root), which only
# happens with an actual chain - a lone self-signed leaf yields error 18
# (self-signed depth-zero cert) instead and the test wouldn't match.
openssl genrsa -out /tmp/memcached-tls-ca.key 2048 2>/dev/null
openssl req -x509 -new -nodes -key /tmp/memcached-tls-ca.key -sha256 -days 3650 \
	-out /tmp/memcached-tls-ca.crt -subj "/CN=test-ca"
openssl genrsa -out /tmp/memcached-tls-leaf.key 2048 2>/dev/null
openssl req -new -key /tmp/memcached-tls-leaf.key -subj "/CN=test.com" -out /tmp/memcached-tls-leaf.csr
openssl x509 -req -in /tmp/memcached-tls-leaf.csr -CA /tmp/memcached-tls-ca.crt \
	-CAkey /tmp/memcached-tls-ca.key -CAcreateserial -days 3650 -sha256 -out /tmp/memcached-tls-leaf.crt
cat /tmp/memcached-tls-leaf.crt /tmp/memcached-tls-ca.crt > /tmp/memcached-tls-chain.crt
memcached-tls -d -u root -p 11212 -Z -o ssl_chain_cert=/tmp/memcached-tls-chain.crt,ssl_key=/tmp/memcached-tls-leaf.key

# Binary name varies by distro/package: plain "redis" (alpine, debian,
# ubuntu), Valkey without a redis-compat package (almalinux, fedora -
# "valkey"), or a versioned "redis6" (amazonlinux).
# redisbloom.so (glibc distros only, see Dockerfile's redisbloom stage):
# gives lua-resty-redis's t/module.t a real "bf" module to test against.
REDIS_SERVER=$(command -v redis-server || command -v valkey-server || command -v redis6-server)
if [ -f /usr/local/lib/redisbloom.so ]; then
	REDIS_LOADMODULE="--loadmodule /usr/local/lib/redisbloom.so"
else
	REDIS_LOADMODULE=""
fi
$REDIS_SERVER --daemonize yes --port 6379 --bind 127.0.0.1 $REDIS_LOADMODULE

mkdir -p /var/run/mysql
mariadb-install-db --user=root --datadir=/var/lib/mysql --auth-root-authentication-method=normal > /var/log/mariadb-install.log 2>&1

# Use the module's own stronger bundled cert (2048-bit/SHA-256) for the
# server's TLS identity: OpenSSL >= 3.0 (default security level) rejects
# the 1024-bit/SHA-1 cert MySQL/MariaDB ship by default in some configs.
# This mirrors lua-resty-mysql's own .travis/initializedb.sh exactly.
cp "/lua-resty-mysql-${VER_OPENRESTY_MYSQL}/t/data/test-sha256.crt" "/lua-resty-mysql-${VER_OPENRESTY_MYSQL}/t/data/test.crt"
cp "/lua-resty-mysql-${VER_OPENRESTY_MYSQL}/t/data/test-sha256.key" "/lua-resty-mysql-${VER_OPENRESTY_MYSQL}/t/data/test.key"

# --skip-networking=0: distro packages ship a default my.cnf with
# `skip-networking` on (socket-only), which silently wins over --port
# unless explicitly overridden - lua-resty-mysql connects over TCP.
# --version=...: Debian/Ubuntu's MariaDB package bakes a "-<pkgsuffix>
# from Debian/Ubuntu" tail onto @@version (e.g. "11.8.6-MariaDB-5ubuntu0.1
# from Ubuntu"); lua-resty-mysql's t/sanity.t and t/ssl.t assert on a
# plain "<ver>-MariaDB" banner with no embedded spaces, so strip it back
# to the plain version (a no-op on distros that don't add one).
# --pid-file: Debian's mariadb-server package (unlike Ubuntu's) never
# creates /run/mysqld - it relies on a systemd tmpfiles.d rule that only
# runs via the package's own service unit, which we bypass by invoking
# mariadbd directly. Its compiled-in mariadb.conf.d default pid-file path
# is under /run/mysqld, so mariadbd fails outright ("Can't create/write
# to file '/run/mysqld/mysqld.pid'") unless redirected to a directory we
# already created ourselves.
MARIADB_VERSION=$(mariadbd --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+-MariaDB')
nohup mariadbd --user=root --datadir=/var/lib/mysql \
	--socket=/var/run/mysql/mysql.sock --port=3306 --bind-address=127.0.0.1 --skip-networking=0 \
	--pid-file=/var/run/mysql/mysqld.pid \
	--version="$MARIADB_VERSION" \
	--ssl-cert="/lua-resty-mysql-${VER_OPENRESTY_MYSQL}/t/data/test.crt" \
	--ssl-key="/lua-resty-mysql-${VER_OPENRESTY_MYSQL}/t/data/test.key" \
	> /var/log/mariadbd.log 2>&1 &
for i in $(seq 1 30); do mariadb-admin --socket=/var/run/mysql/mysql.sock ping 2>/dev/null && break; sleep 1; done

# Fresh mariadb-install-db data dirs ship an anonymous ''@'<host>' user;
# it outranks 'ngx_test'@'%' for any connection whose client host
# resolves to that exact hostname (e.g. "localhost"), causing "Access
# denied" even with the right credentials. mysql_secure_installation
# does the same cleanup for the same reason.
mariadb --socket=/var/run/mysql/mysql.sock -u root -e \
	"DELETE FROM mysql.user WHERE User=''; \
	CREATE DATABASE IF NOT EXISTS ngx_test; \
	ALTER DATABASE ngx_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; \
	CREATE USER IF NOT EXISTS 'ngx_test'@'%' IDENTIFIED BY 'ngx_test'; \
	GRANT ALL PRIVILEGES ON ngx_test.* TO 'ngx_test'@'%'; \
	CREATE DATABASE IF NOT EXISTS world; \
	GRANT ALL PRIVILEGES ON world.* TO 'ngx_test'@'%'; \
	CREATE USER IF NOT EXISTS 'user_native'@'%' IDENTIFIED BY 'pass_native'; \
	GRANT ALL PRIVILEGES ON ngx_test.* TO 'user_native'@'%'; \
	CREATE USER IF NOT EXISTS 'nopass_native'@'%' IDENTIFIED WITH mysql_native_password; \
	GRANT ALL PRIVILEGES ON ngx_test.* TO 'nopass_native'@'%'; \
	FLUSH PRIVILEGES;"
zcat "/lua-resty-mysql-${VER_OPENRESTY_MYSQL}/t/data/world.sql.gz" | mariadb --socket=/var/run/mysql/mysql.sock -u root world

# t/ed25519.t (client_ed25519, MariaDB 10.2+): the two base64 strings are
# precomputed Ed25519 public keys for password "ed25519_pass" and "" -
# same values and USING form lua-resty-mysql's own .travis/initializedb.sh
# uses (USING PASSWORD(...) only works on 10.4+; this form works on all
# versions that ship the plugin, including 11.x where PASSWORD('') writes
# an unusable empty authentication_string).
mariadb --socket=/var/run/mysql/mysql.sock -u root -e "INSTALL SONAME 'auth_ed25519';" || true
mariadb --socket=/var/run/mysql/mysql.sock -u root -e \
	"CREATE USER IF NOT EXISTS 'ed25519_user'@'%' IDENTIFIED VIA ed25519 USING 'STIwVk/F6qiXJuOr8AgPSWVxmiN3rUjEX5DfzGAJ32A'; \
	GRANT ALL PRIVILEGES ON ngx_test.* TO 'ed25519_user'@'%'; \
	CREATE USER IF NOT EXISTS 'ed25519_nopass'@'%' IDENTIFIED VIA ed25519 USING '4LH+dBF+G5W2CKTyId8xR3SyDqZoQjUNUVNxx8aWbG4'; \
	GRANT ALL PRIVILEGES ON ngx_test.* TO 'ed25519_nopass'@'%'; \
	FLUSH PRIVILEGES;"

# lua-resty-redis's t/ssl.t drives a mock TLS backend via nginx's own
# ssl_certificate directive pointed at this bundled cert (it's not
# redis-server's own TLS) - same 1024-bit/SHA-1 problem, regenerate it.
openssl req -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes \
	-keyout "/lua-resty-redis-${VER_OPENRESTY_REDIS}/t/cert/test.key" \
	-out "/lua-resty-redis-${VER_OPENRESTY_REDIS}/t/cert/test.crt" \
	-subj "/CN=localhost"
