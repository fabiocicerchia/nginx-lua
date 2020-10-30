FORCE=1
BUILD_CMD=./bin/docker-build.sh
PUSH_CMD=./bin/docker-push.sh
TEST_CMD=./bin/test.sh
SEC_CMD=./bin/test-security.sh
META_CMD=./bin/docker-metadata.sh

################################################################################
# UTILITIES
################################################################################
auto-update: generate-supported-versions generate-dockerfiles update-tags

auto-update-and-commit: auto-update
	set -eux
	export TAG_VER="v1.$(date +%Y%m%d)"
	git config --global user.name "fabiocicerchia"
	git config --global user.email "fabiocicerchia@users.noreply.github.com"
	git add -A
	git commit -m "Automated updates"
	git remote set-url --push origin "https://fabiocicerchia:${GH_TOKEN}@github.com/fabiocicerchia/nginx-lua.git"
	git push origin HEAD:master

auto-commit-metadata: generate-metadata
	set -eux
	git config --global user.name "fabiocicerchia"
	git config --global user.email "fabiocicerchia@users.noreply.github.com"
	git add -A
	git commit -m "Automated metadata"
	git remote set-url --push origin "https://fabiocicerchia:${GH_TOKEN}@github.com/fabiocicerchia/nginx-lua.git"
	git push origin HEAD:master

generate-supported-versions:
	./bin/generate-supported-versions.sh

generate-dockerfiles:
	./bin/generate-dockerfiles.sh

generate-metadata:
	$(META_CMD) alpine
	$(META_CMD) amazonlinux
	$(META_CMD) centos
	$(META_CMD) debian
	$(META_CMD) fedora
	$(META_CMD) ubuntu

update-tags:
	./bin/generate_tags.py | tee docs/TAGS.md

update-readme:
	./bin/update-readme.sh

benchmark:
	./bin/benchmark.sh

################################################################################
# GENERIC
################################################################################

all: build-all test-all push-all

################################################################################
# BUILD
################################################################################

build-all: build-alpine build-amazonlinux build-centos build-debian build-fedora build-ubuntu

build-alpine:
	$(BUILD_CMD) alpine $(FORCE)
	$(META_CMD) alpine

build-amazonlinux:
	$(BUILD_CMD) amazonlinux $(FORCE)
	$(META_CMD) amazonlinux

build-centos:
	$(BUILD_CMD) centos $(FORCE)
	$(META_CMD) centos

build-debian:
	$(BUILD_CMD) debian $(FORCE)
	$(META_CMD) debian

build-fedora:
	$(BUILD_CMD) fedora $(FORCE)
	$(META_CMD) fedora

build-ubuntu:
	$(BUILD_CMD) ubuntu $(FORCE)
	$(META_CMD) ubuntu

################################################################################
# BUILD MINIMAL
################################################################################

build-all-minimal: build-alpine-minimal build-amazonlinux-minimal build-centos-minimal build-debian-minimal build-fedora-minimal build-ubuntu-minimal

build-alpine-minimal:
	$(BUILD_CMD) alpine $(FORCE) 0

build-amazonlinux-minimal:
	$(BUILD_CMD) amazonlinux $(FORCE) 0

build-centos-minimal:
	$(BUILD_CMD) centos $(FORCE) 0

build-debian-minimal:
	$(BUILD_CMD) debian $(FORCE) 0

build-fedora-minimal:
	$(BUILD_CMD) fedora $(FORCE) 0

build-ubuntu-minimal:
	$(BUILD_CMD) ubuntu $(FORCE) 0

################################################################################
# TESTING
################################################################################

test-all: test-alpine test-amazonlinux test-centos test-debian test-fedora test-ubuntu test-lint test-security

test-alpine:
	$(TEST_CMD) alpine

test-amazonlinux:
	$(TEST_CMD) amazonlinux

test-centos:
	$(TEST_CMD) centos

test-debian:
	$(TEST_CMD) debian

test-fedora:
	$(TEST_CMD) fedora

test-ubuntu:
	$(TEST_CMD) ubuntu

test-lint:
	./bin/test-lint.sh

test-security: test-security-alpine test-security-amazonlinux test-security-centos test-security-debian test-security-fedora test-security-ubuntu

test-security-alpine:
	$(SEC_CMD) alpine

test-security-amazonlinux:
	$(SEC_CMD) amazonlinux

test-security-centos:
	$(SEC_CMD) centos

test-security-debian:
	$(SEC_CMD) debian

test-security-fedora:
	$(SEC_CMD) fedora

test-security-ubuntu:
	$(SEC_CMD) ubuntu

################################################################################
# PUSH
################################################################################

push-all: push-alpine push-amazonlinux push-centos push-debian push-fedora push-ubuntu

push-alpine:
	$(PUSH_CMD) alpine $(FORCE)

push-amazonlinux:
	$(PUSH_CMD) amazonlinux $(FORCE)

push-centos:
	$(PUSH_CMD) centos $(FORCE)

push-debian:
	$(PUSH_CMD) debian $(FORCE)

push-fedora:
	$(PUSH_CMD) fedora $(FORCE)

push-ubuntu:
	$(PUSH_CMD) ubuntu $(FORCE)