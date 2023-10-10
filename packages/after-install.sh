#/bin/sh

source /etc/os-release

if [ "$ID" == "alpine" ]; then
    addgroup -g 101 -S nginx
    adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx
elif [ "$ID_LIKE" == "debian" ]; then
    addgroup --system --gid 101 nginx
    adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx
elif [ -x /usr/sbin/useradd ]; then
    groupadd --system --gid 101 nginx
    useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 101 nginx
fi
