#!/bin/bash
npm install artillery
docker-compose -f docker-compose.test.yml up
echo "ARTILLERY - NGINX"
./node_modules/.bin/artillery run test/artillery-nginx.yml 
echo "ARTILLERY - NGINX-LUA"
./node_modules/.bin/artillery run test/artillery-nginx-lua.yml 
echo "ARTILLERY - OPENRESTY"
./node_modules/.bin/artillery run test/artillery-openresty.yml 