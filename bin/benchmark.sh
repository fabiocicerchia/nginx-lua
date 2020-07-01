#!/bin/bash
# shellcheck disable=SC2086,SC2178,SC1091,SC2004

# VM: ubuntu-s-1vcpu-2gb-fra1-01

# SETUP
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# RUN
npm install artillery
docker-compose -f docker-compose.test.yml up -d

echo "ARTILLERY - NGINX"
./node_modules/.bin/artillery run test/artillery-nginx.yml > artillery.nginx.1.txt
echo "ARTILLERY - NGINX-LUA"
./node_modules/.bin/artillery run test/artillery-nginx-lua.yml > artillery.nginx-lua.1.txt
echo "ARTILLERY - OPENRESTY"
./node_modules/.bin/artillery run test/artillery-openresty.yml > artillery.openresty.1.txt

echo "ARTILLERY - NGINX"
./node_modules/.bin/artillery run test/artillery-nginx.yml > artillery.nginx.2.txt
echo "ARTILLERY - NGINX-LUA"
./node_modules/.bin/artillery run test/artillery-nginx-lua.yml > artillery.nginx-lua.2.txt
echo "ARTILLERY - OPENRESTY"
./node_modules/.bin/artillery run test/artillery-openresty.yml > artillery.openresty.2.txt

echo "ARTILLERY - NGINX"
./node_modules/.bin/artillery run test/artillery-nginx.yml > artillery.nginx.3.txt
echo "ARTILLERY - NGINX-LUA"
./node_modules/.bin/artillery run test/artillery-nginx-lua.yml > artillery.nginx-lua.3.txt
echo "ARTILLERY - OPENRESTY"
./node_modules/.bin/artillery run test/artillery-openresty.yml > artillery.openresty.3.txt

echo "ARTILLERY - NGINX"
./node_modules/.bin/artillery run test/artillery-nginx.yml > artillery.nginx.4.txt
echo "ARTILLERY - NGINX-LUA"
./node_modules/.bin/artillery run test/artillery-nginx-lua.yml > artillery.nginx-lua.4.txt
echo "ARTILLERY - OPENRESTY"
./node_modules/.bin/artillery run test/artillery-openresty.yml > artillery.openresty.4.txt

echo "ARTILLERY - NGINX"
./node_modules/.bin/artillery run test/artillery-nginx.yml > artillery.nginx.5.txt
echo "ARTILLERY - NGINX-LUA"
./node_modules/.bin/artillery run test/artillery-nginx-lua.yml > artillery.nginx-lua.5.txt
echo "ARTILLERY - OPENRESTY"
./node_modules/.bin/artillery run test/artillery-openresty.yml > artillery.openresty.5.txt

#####

echo "ARTILLERY - ALPINE"
./node_modules/.bin/artillery run test/artillery-alpine.yml > artillery.alpine.1.txt
echo "ARTILLERY - UBUNTU"
./node_modules/.bin/artillery run test/artillery-ubuntu.yml > artillery.ubuntu.1.txt
echo "ARTILLERY - DEBIAN"
./node_modules/.bin/artillery run test/artillery-debian.yml > artillery.debian.1.txt
echo "ARTILLERY - FEDORA"
./node_modules/.bin/artillery run test/artillery-fedora.yml > artillery.fedora.1.txt
echo "ARTILLERY - CENTOS"
./node_modules/.bin/artillery run test/artillery-centos.yml > artillery.centos.1.txt

echo "ARTILLERY - ALPINE"
./node_modules/.bin/artillery run test/artillery-alpine.yml > artillery.alpine.2.txt
echo "ARTILLERY - UBUNTU"
./node_modules/.bin/artillery run test/artillery-ubuntu.yml > artillery.ubuntu.2.txt
echo "ARTILLERY - DEBIAN"
./node_modules/.bin/artillery run test/artillery-debian.yml > artillery.debian.2.txt
echo "ARTILLERY - FEDORA"
./node_modules/.bin/artillery run test/artillery-fedora.yml > artillery.fedora.2.txt
echo "ARTILLERY - CENTOS"
./node_modules/.bin/artillery run test/artillery-centos.yml > artillery.centos.2.txt

echo "ARTILLERY - ALPINE"
./node_modules/.bin/artillery run test/artillery-alpine.yml > artillery.alpine.3.txt
echo "ARTILLERY - UBUNTU"
./node_modules/.bin/artillery run test/artillery-ubuntu.yml > artillery.ubuntu.3.txt
echo "ARTILLERY - DEBIAN"
./node_modules/.bin/artillery run test/artillery-debian.yml > artillery.debian.3.txt
echo "ARTILLERY - FEDORA"
./node_modules/.bin/artillery run test/artillery-fedora.yml > artillery.fedora.3.txt
echo "ARTILLERY - CENTOS"
./node_modules/.bin/artillery run test/artillery-centos.yml > artillery.centos.3.txt

echo "ARTILLERY - ALPINE"
./node_modules/.bin/artillery run test/artillery-alpine.yml > artillery.alpine.4.txt
echo "ARTILLERY - UBUNTU"
./node_modules/.bin/artillery run test/artillery-ubuntu.yml > artillery.ubuntu.4.txt
echo "ARTILLERY - DEBIAN"
./node_modules/.bin/artillery run test/artillery-debian.yml > artillery.debian.4.txt
echo "ARTILLERY - FEDORA"
./node_modules/.bin/artillery run test/artillery-fedora.yml > artillery.fedora.4.txt
echo "ARTILLERY - CENTOS"
./node_modules/.bin/artillery run test/artillery-centos.yml > artillery.centos.4.txt

echo "ARTILLERY - ALPINE"
./node_modules/.bin/artillery run test/artillery-alpine.yml > artillery.alpine.5.txt
echo "ARTILLERY - UBUNTU"
./node_modules/.bin/artillery run test/artillery-ubuntu.yml > artillery.ubuntu.5.txt
echo "ARTILLERY - DEBIAN"
./node_modules/.bin/artillery run test/artillery-debian.yml > artillery.debian.5.txt
echo "ARTILLERY - FEDORA"
./node_modules/.bin/artillery run test/artillery-fedora.yml > artillery.fedora.5.txt
echo "ARTILLERY - CENTOS"
./node_modules/.bin/artillery run test/artillery-centos.yml > artillery.centos.5.txt

echo Nginx
TESTS=$(grep -r virtual docs/benchmark/reports/different_images/*nginx.* -A10 | grep 'median' | sed 's/.*: //' | sort -n | tail -n4 | head -n3 | tr '\n' '+')
echo "scale=2; (${TESTS%?})/3" | bc
echo Nginx-Lua
TESTS=$(grep -r virtual docs/benchmark/reports/different_images/*nginx-lua* -A10 | grep 'median' | sed 's/.*: //' | sort -n | tail -n4 | head -n3 | tr '\n' '+')
echo "scale=2; (${TESTS%?})/3" | bc
echo OpenResty
TESTS=$(grep -r virtual docs/benchmark/reports/different_images/*openresty* -A10 | grep 'median' | sed 's/.*: //' | sort -n | tail -n4 | head -n3 | tr '\n' '+')
echo "scale=2; (${TESTS%?})/3" | bc

echo Alpine
TESTS=$(grep -r virtual docs/benchmark/reports/distros/*alpine* -A10 | grep 'median' | sed 's/.*: //' | sort -n | tail -n4 | head -n3 | tr '\n' '+')
echo "scale=2; (${TESTS%?})/3" | bc
echo Ubuntu
TESTS=$(grep -r virtual docs/benchmark/reports/distros/*ubuntu* -A10 | grep 'median' | sed 's/.*: //' | sort -n | tail -n4 | head -n3 | tr '\n' '+')
echo "scale=2; (${TESTS%?})/3" | bc
echo Debian
TESTS=$(grep -r virtual docs/benchmark/reports/distros/*debian* -A10 | grep 'median' | sed 's/.*: //' | sort -n | tail -n4 | head -n3 | tr '\n' '+')
echo "scale=2; (${TESTS%?})/3" | bc
echo Fedora
TESTS=$(grep -r virtual docs/benchmark/reports/distros/*fedora* -A10 | grep 'median' | sed 's/.*: //' | sort -n | tail -n4 | head -n3 | tr '\n' '+')
echo "scale=2; (${TESTS%?})/3" | bc
echo Centos
TESTS=$(grep -r virtual docs/benchmark/reports/distros/*centos* -A10 | grep 'median' | sed 's/.*: //' | sort -n | tail -n4 | head -n3 | tr '\n' '+')
echo "scale=2; (${TESTS%?})/3" | bc
