build-all: build-alpine build-centos build-amazonlinux build-fedora build-debian build-ubuntu

build-alpine:
	./bin/docker-build.sh alpine 1

build-centos:
	./bin/docker-build.sh centos 1

build-amazonlinux:
	./bin/docker-build.sh amazonlinux 1

build-fedora:
	./bin/docker-build.sh fedora 1

build-debian:
	./bin/docker-build.sh debian 1

build-ubuntu:
	./bin/docker-build.sh ubuntu 1

push-all: push-alpine push-centos push-amazonlinux push-fedora push-debian push-ubuntu

push-alpine:
	./bin/docker-push.sh alpine 1

push-centos:
	./bin/docker-push.sh centos 1

push-amazonlinux:
	./bin/docker-push.sh amazonlinux 1

push-fedora:
	./bin/docker-push.sh fedora 1

push-debian:
	./bin/docker-push.sh debian 1

push-ubuntu:
	./bin/docker-push.sh ubuntu 1

test-all: test-alpine test-centos test-amazonlinux test-fedora test-debian test-ubuntu

test-alpine:
	./bin/test.sh alpine 1

test-centos:
	./bin/test.sh centos 1

test-amazonlinux:
	./bin/test.sh amazonlinux 1

test-fedora:
	./bin/test.sh fedora 1

test-debian:
	./bin/test.sh debian 1

test-ubuntu:
	./bin/test.sh ubuntu 1