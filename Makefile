#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2023 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

PAGER:=
DOCKERFILE_CHANGES=$(shell (git fetch origin main > /dev/null; git diff-tree --no-commit-id --name-only -r origin/main) | egrep "(nginx|tpl)/" | wc -l | tr -d ' ')
ifeq ($(DOCKERFILE_CHANGES), 0)
	SKIP=YES
else
	SKIP=NO
endif
ifeq ($(FORCE), YES)
	SKIP=NO
endif
BUILD_CMD:=./bin/docker-build.py
PUSH_CMD:=./bin/docker-push.py
BUNDLE_CMD:=./bin/docker-bundle.py
TEST_CMD:=./bin/test.sh
SEC_CMD:=./bin/test-security.sh
META_CMD:=./bin/docker-metadata.py
META_ALL_CMD:=./bin/docker-metadata-all.py
DISTROS=almalinux alpine amazonlinux debian fedora ubuntu

PREVIOUS_TAG=$(shell git ls-remote --tags 2>&1 | awk '{print $$2}' | sort -r | head -n 1 | cut -d "/" -f3)
TAG_VER=$(shell date +'v1.%Y%m%d.%H%M%S')
CHANGELOG=$(shell $(MAKE) changelog)

SUPPORTED_NGINX_VER=$(shell cat supported_versions | grep nginx | cut -d= -f2)
SUPPORTED_ALPINE_VER=$(shell cat supported_versions | grep alpine | cut -d= -f2)
SUPPORTED_FEDORA_VER=$(shell cat supported_versions | grep fedora | cut -d= -f2)
SUPPORTED_UBUNTU_VER=$(shell cat supported_versions | grep ubuntu | cut -d= -f2)

amd64_distros=$(addprefix amd64-, $(DISTROS))
arm64_distros=$(addprefix arm64v8-, $(DISTROS))
classic_distros_amd64=$(addsuffix -classic, $(amd64_distros))
classic_distros_arm64=$(addsuffix -classic, $(arm64_distros))
build_targets_amd64=$(addprefix build-, $(classic_distros_amd64))
build_targets_arm64=$(addprefix build-, $(classic_distros_arm64))
build_targets=${build_targets_amd64} ${build_targets_arm64}
# CircleCI workaround
cci_arm64_distros=$(addprefix large-, $(DISTROS))
cci_amd64_distros=$(addprefix arm.medium-, $(DISTROS))
cci_arch_distros=$(cci_amd64_distros) $(cci_arm64_distros)
cci_classic_distros=$(addsuffix -classic, $(cci_arch_distros))
cci_build_targets=$(addprefix build-, $(cci_classic_distros))
# / CircleCI workaround

test_targets=$(addprefix test-, $(DISTROS))
push_targets=$(addprefix push-, $(DISTROS))
bundle_targets=$(addprefix bundle-, $(DISTROS))
security_targets=$(addprefix test-security-, $(DISTROS))
minimal_targets=$(addprefix build-minimal-, $(DISTROS))

.PHONY: changelog
.SILENT: help changelog
default: help

################################################################################
##@ GENERIC
################################################################################

all: build-all test-all push-all ## build, test and push everything

################################################################################
# HELP
################################################################################

help: ## prints this help
	echo "              __                     __ "
	echo ".-----.-----.|__|.-----.--.--.______|  |.--.--.---.-."
	echo "|     |  _  ||  ||     |_   _|______|  ||  |  |  _  |"
	echo "|__|__|___  ||__||__|__|__.__|      |__||_____|___._|"
	echo "      |_____|"
	echo ""
	echo "Copyright (c) 2023 Fabio Cicerchia. https://fabiocicerchia.it. MIT License"
	echo "Repo: https://github.com/fabiocicerchia/nginx-lua"
	echo ""
	@gawk 'function fix_value(value, str) { \
		padding=sprintf("%50s",""); \
		ret=gensub("([^ ]+)", "\\1"padding"\n ", "g", "  "value); \
		ret=gensub("(^|\n)(.{53}) *", "\\1\\2\033[0m"str"  \033[36m", "g", ret); \
		ret=substr(ret, 3, length(ret)-16-length(str)); \
		return ret; \
	} \
	BEGIN { \
		FS = ":.*##"; \
		printf "Use: make \033[36m<target>\033[0m\n"; \
	} /^\$$?\(?[a-zA-Z0-9_-]+\)?:.*?##/ { \
		gsub("\\$$\\(build_targets\\)",        fix_value("$(build_targets)", $$2),        $$1); \
		gsub("\\$$\\(build_targets_amd64\\)",  fix_value("$(build_targets_amd64)", $$2),  $$1); \
		gsub("\\$$\\(build_targets_arm64\\)",  fix_value("$(build_targets_arm64)", $$2),  $$1); \
		gsub("\\$$\\(cci_build_targets\\)",    fix_value("$(cci_build_targets)", $$2),    $$1); \
		gsub("\\$$\\(minimal_targets\\)",      fix_value("$(minimal_targets)", $$2),      $$1); \
		gsub("\\$$\\(test_targets\\)",         fix_value("$(test_targets)", $$2),         $$1); \
		gsub("\\$$\\(security_targets\\)",     fix_value("$(security_targets)", $$2),     $$1); \
		gsub("\\$$\\(push_targets\\)",         fix_value("$(push_targets)", $$2),         $$1); \
		gsub("\\$$\\(bundle_targets\\)",       fix_value("$(bundle_targets)", $$2),       $$1); \
		printf "  \033[36m%-50s\033[0m %s\n", $$1, $$2 \
	} /^##@/ { \
		printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	}' $(MAKEFILE_LIST)

################################################################################
##@ BUILD
################################################################################

build-all: build-amd64 build-arm64 ## build all dockerfiles
build-amd64: $(build_targets_amd64) ## build all distros in amd64 arch
build-arm64: $(build_targets_arm64) ## build all distros in arm64 arch

$(build_targets_amd64): ## build one distro in amd64 arch
	TASK=$(@) $(MAKE) build-single

$(build_targets_arm64): ## build one distro in arm64/v8 arch
	TASK=$(@) $(MAKE) build-single

$(cci_build_targets): ## build one distro in one arch (CircleCI internals)
	TASK=$(@) $(MAKE) build-single

build-single: generate-dockerfiles
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
else
	ARCH=$(shell echo $$TASK | cut -d"-" -f2); \
	DISTRO=$(shell echo $$TASK | cut -d"-" -f3); \
	echo "BUILDING $$DISTRO"; \
	export DOCKER_CLI_EXPERIMENTAL=enabled; \
	$(BUILD_CMD) "$$DISTRO" "$$ARCH" \
	&& $(META_CMD) "$$DISTRO"
endif

################################################################################
##@ TESTING
################################################################################

test-all: $(test_targets) ## test all docker images

$(test_targets): ## test one docker image
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
else
	DISTRO=$(subst test-,,$(@)); \
	echo "TESTING $$DISTRO"; \
	$(TEST_CMD) "$$DISTRO" "amd64"
	$(TEST_CMD) "$$DISTRO" "arm64"
endif

test-security: $(security_targets) ## test security all docker images

$(security_targets): ## test security one docker images
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
else
	DISTRO=$(subst test-security-,,$(@)); \
	echo "SECURITY $$DISTRO"; \
	$(SEC_CMD) "$$DISTRO"
endif

################################################################################
##@ PUSH
################################################################################

push-all: $(push_targets) ## push all docker images to docker hub

$(push_targets): ## push one docker images to docker hub
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
else
	DISTRO=$(subst push-,,$(@)); \
	echo "PUSHING $$DISTRO"; \
	$(PUSH_CMD) "$$DISTRO"
endif

################################################################################
##@ BUNDLE
################################################################################

$(bundle_targets): ## bundle multiple docker images into one
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
else
	DISTRO=$(subst bundle-,,$(@)); \
	echo "BUNDLING $$DISTRO"; \
	$(BUNDLE_CMD) "$$DISTRO"
endif

################################################################################
##@ DEPENDENCIES
################################################################################
# Ref: https://www.stereolabs.com/docs/docker/building-arm-container-on-x86/
qemu:
	docker buildx create --name multiarch --use
	sudo apt-get update
	sudo apt-get install --force-yes qemu binfmt-support qemu-user-static # Install the qemu packages
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes # This step will execute the registering scripts

################################################################################
##@ PACKAGE
################################################################################

packages: ## creating the system package .apk (Alpine), .deb (Debian-like), .rpm (RHEL-like)
	make package-apk
	make package-deb
	make package-rpm

package-apk: PACKAGE_TYPE=apk
package-apk: DISTRO=alpine
package-apk: OS_VER=$(SUPPORTED_ALPINE_VER)
package-apk: .package-base ## creating the system package .apk (Alpine)

package-deb: PACKAGE_TYPE=deb
package-deb: DISTRO=ubuntu
package-deb: OS_VER=$(SUPPORTED_UBUNTU_VER)
package-deb: .package-base ## creating the system package .deb (Debian-like)

package-rpm: PACKAGE_TYPE=rpm
package-rpm: DISTRO=fedora
package-rpm: OS_VER=$(SUPPORTED_FEDORA_VER)
package-rpm: .package-base ## creating the system package .rpm (RHEL-like)

.package-base:
	docker build \
		-f packages/Dockerfile-$(PACKAGE_TYPE).package \
		-t package-nginx-$(PACKAGE_TYPE) \
		--build-arg NGINX_VERSION="$(SUPPORTED_NGINX_VER)" \
		--build-arg DISTRO="$(DISTRO)" \
		--build-arg OS_VERSION="$(OS_VER)" \
		--build-arg FPM_OUTPUT_TYPE="$(PACKAGE_TYPE)" \
		packages
	docker rm -f extract-$(PACKAGE_TYPE) || true
	docker run -d --name extract-$(PACKAGE_TYPE) package-nginx-$(PACKAGE_TYPE) && \
	docker cp extract-$(PACKAGE_TYPE):$$(docker exec extract-$(PACKAGE_TYPE) sh -c "ls -1 /nginx-lua*.$(PACKAGE_TYPE)") .
	docker rm -f extract-$(PACKAGE_TYPE)

package-test: package-test-apk package-test-deb package-test-rpm ## testing installation of the system package .apk (Alpine), .deb (Debian-like), .rpm (RHEL-like)

package-test-apk: ## testing installation of the system package .apk (Alpine)
	docker rm -f test-apk || true
	docker run --name test-apk -v $$PWD/packages:/app -d alpine:latest sleep infinity
	docker exec test-apk /bin/sh -c "apk add -v --allow-untrusted /app/*.apk"
	docker exec test-apk /bin/sh -c "envsubst -V \
		&& nginx -V \
		&& nginx -t \
		&& luajit -v \
		&& lua -v \
		&& luarocks --version"
	docker rm -f test-apk

package-test-deb: ## testing installation of the system package .deb (Debian-like)
	docker rm -f test-deb || true
	docker run --name test-deb -v $$PWD/packages:/app -d ubuntu:latest sleep infinity
	docker exec test-deb /bin/sh -c "apt update && apt install -yf /app/*.deb"
	docker exec test-deb /bin/sh -c "envsubst -V \
		&& nginx -V \
		&& nginx -t \
		&& luajit -v \
		&& lua -v \
		&& luarocks --version"
	# docker rm -f test-deb

package-test-rpm: ## testing installation of the system package .rpm (RHEL-like)
	docker rm -f test-rpm || true
	docker run --name test-rpm -v $$PWD/packages:/app -d fedora:latest sleep infinity
	docker exec test-rpm /bin/sh -c "yum localinstall -y /app/*.rpm"
	docker exec test-rpm /bin/sh -c "envsubst -V \
		&& nginx -V \
		&& nginx -t \
		&& luajit -v \
		&& lua -v \
		&& luarocks --version"
	docker rm -f test-rpm

################################################################################
##@ UTILITIES
################################################################################
auto-update: generate-supported-versions pull-nginx-entrypoints generate-dockerfiles update-readme update-tags ## auto update supported versions, dockerfiles and tags

.setup_gitrepo:
	git config --global user.name "fabiocicerchia"
	git config --global user.email "fabiocicerchia@users.noreply.github.com"
	git remote set-url --push origin "https://fabiocicerchia:${GITHUB_TOKEN}@github.com/fabiocicerchia/nginx-lua.git"

auto-update-and-commit: .setup_gitrepo auto-update
	git add -A || true; \
	CHANGES=$(git status | grep "Changes to be committed" | wc -l | tr -d ' '); \
	if [ "$$CHANGES" != "0" ]; then \
		git commit -m "Automated updates"; \
		git pull origin main || true; \
		git push origin main; \
	else \
		exit 1; \
	fi

auto-commit-metadata: .setup_gitrepo generate-metadata
	git add -A || true; \
	CHANGES=$(git status | grep "Changes to be committed" | wc -l | tr -d ' '); \
	if [ "$$CHANGES" != "0" ]; then \
		git commit -m "Automated metadata"; \
		git pull origin main || true; \
		git push origin main; \
	else \
		exit 1; \
	fi

release: ## create a github release
	mkdir -p dist && rm -rf dist/*
	cp Dockerfile dist/
	tail -n -6 supported_versions | tr '=' '/' | sed 's_^_nginx/$(SUPPORTED_NGINX_VER)/_' | xargs find | grep Dockerfile | while read file; do cp $$file dist/$$(echo $$file | sed 's_nginx/\(.*\)/\(.*\)/\(.*\)/\(Dockerfile.*\)_\4-nginx\1-\2\3_'); done
	wget https://github.com/tcnksm/ghr/releases/download/v0.16.0/ghr_v0.16.0_linux_amd64.tar.gz
	tar xvzf ghr_v0.16.0_linux_amd64.tar.gz
	if [ "$(shell git log --pretty=format:'- %B' $(PREVIOUS_TAG)..HEAD)" != "" ]; then \
		./ghr_v0.16.0_linux_amd64/ghr -b "$$(printf '%q' $($(MAKE) --no-print-directory changelog))" $(TAG_VER) dist; \
	fi

generate-supported-versions: ## generate supported_versions file
	./bin/generate-supported-versions.sh

generate-dockerfiles: ## generate all dockerfiles
	./bin/generate-dockerfiles.py

pull-nginx-entrypoints: ## retrieves the official entrypoint files
	curl -sLo tpl/10-listen-on-ipv6-by-default.sh https://raw.githubusercontent.com/nginxinc/docker-nginx/$(SUPPORTED_NGINX_VER)/entrypoint/10-listen-on-ipv6-by-default.sh
	curl -sLo tpl/20-envsubst-on-templates.sh https://raw.githubusercontent.com/nginxinc/docker-nginx/$(SUPPORTED_NGINX_VER)/entrypoint/20-envsubst-on-templates.sh
	curl -sLo tpl/30-tune-worker-processes.sh https://raw.githubusercontent.com/nginxinc/docker-nginx/$(SUPPORTED_NGINX_VER)/entrypoint/30-tune-worker-processes.sh
	curl -sLo tpl/docker-entrypoint.sh https://raw.githubusercontent.com/nginxinc/docker-nginx/$(SUPPORTED_NGINX_VER)/entrypoint/docker-entrypoint.sh
	patch tpl/docker-entrypoint.sh tpl/docker-entrypoint.sh.patch

generate-metadata: ## generate metadata for all OS docker images
	for DISTRO in $(DISTROS); do \
		$(META_CMD) $$DISTRO 0; \
	done

generate-metadata-all: ## generate all metadata for all OS docker images
	for DISTRO in $(DISTROS); do \
		$(META_ALL_CMD) $$DISTRO; \
	done

update-tags: ## update docker tags file
	./bin/generate_tags.py | tee docs/TAGS.md

update-readme: ## update supported docker tags in readme
	./bin/update-readme.sh

benchmark: ## benchmark (wip)
	./bin/benchmark.sh

changelog: ## generate a changelog since previous tag
	git fetch --all --tags > /dev/null
	echo "## What's Changed"
	git log --pretty=format:"- %B" $(PREVIOUS_TAG)..HEAD | tr '\r' '\n' | tr 'A-Z' 'a-z' | grep -Ev '^$$' | sed 's/ *[-*]/ -/' | uniq | tee CHANGELOG
	cat CHANGELOG | egrep -v "Automated (metadata|updates)" | sed -e 's/^*/-/' -e 's/"/\\"/g' -e 's/^[ \t]*//' -e 's/^-[ \t]*//' -e 's/^-[ \t]*//' -e 's/^/ - /' | awk '!x[$$0]++' | tee CHANGELOG
	echo ""
	echo "**Full Changelog**: https://github.com/fabiocicerchia/nginx-lua/compare/$(PREVIOUS_TAG)...$(TAG_VER)"
	echo ""
	echo "## Supported Versions"
	cat supported_versions | sed 's/[()"]//g' | tr 'A-Z' 'a-z' | sed 's/^/ - /'
