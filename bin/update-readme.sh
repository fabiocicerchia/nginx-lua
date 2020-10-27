#!/bin/bash

head -n "$(grep -n START_SUPPORTED_TAGS README.md | cut -d: -f1)" README.md > README.md.tmp
./bin/readme-tags.sh >> README.md.tmp
tail -n "$(($(wc -l < README.md)-$(grep -n END_SUPPORTED_TAGS README.md | cut -d: -f1)+1))" README.md >> README.md.tmp
mv README.md.tmp README.md