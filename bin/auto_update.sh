#!/bin/bash
# shellcheck disable=SC2086,SC2178,SC1091,SC2004

set -x

./bin/generate_supported_versions.sh
./bin/dockerfile-generate.sh
./bin/generate_tags.py | tee docs/TAGS.md
git config --global user.name "fabiocicerchia"
git config --global user.email "fabiocicerchia@users.noreply.github.com"
git add -A
git commit -m "Automated updates"
set +x
git remote set-url --push origin "https://fabiocicerchia:${GH_TOKEN}@github.com/fabiocicerchia/nginx-lua.git"
set -x
git push origin HEAD:master
