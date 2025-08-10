#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2025 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

PAGER:=
DOCKERFILE_CHANGES=$(shell (git fetch origin main > /dev/null; git diff-tree --no-commit-id --name-only -r origin/main) | egrep "(nginx|src)/" | wc -l | tr -d ' ')
SKIP=NO
ifeq ($(DOCKERFILE_CHANGES), 0)
	SKIP=YES
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
DISTROS=almalinux alpine amazonlinux debian fedora ubuntu

GH_USERNAME=fabiocicerchia
GH_CLI_NAME=ghr_v0.16.2_linux_amd64
GH_CLI_TARBALL=https://github.com/tcnksm/ghr/releases/download/v0.16.2/$(GH_CLI_NAME).tar.gz
NGINX_UPSTREAM_URL=https://github.com/nginxinc/docker-nginx
NGINX_UPSTREAM_RAW_FILES=https://raw.githubusercontent.com/nginxinc/docker-nginx

PREVIOUS_TAG=$(shell git ls-remote --tags 2>&1 | awk '{print $$2}' | sort -r | head -n 1 | cut -d "/" -f3)
TAG_VER=$(shell date +'v1.%Y%m%d.%H%M%S')
CHANGELOG=$(shell $(MAKE) changelog)

SUPPORTED_NGINX_VER_MAINLINE=$(shell cat supported_versions | grep nginx_mainline | cut -d= -f2)
SUPPORTED_NGINX_VER_STABLE=$(shell cat supported_versions | grep nginx_stable | cut -d= -f2)

amd64_distros=$(addprefix amd64-, $(DISTROS))
arm64_distros=$(addprefix arm64-, $(DISTROS))
build_targets_amd64=$(addprefix build-, $(amd64_distros))
build_targets_arm64=$(addprefix build-, $(arm64_distros))
dockertest_targets_amd64=$(addprefix docker-test-, $(amd64_distros))
dockertest_targets_arm64=$(addprefix docker-test-, $(arm64_distros))
build_targets=${build_targets_amd64} ${build_targets_arm64}
package_targets_amd64=$(addprefix package-, $(amd64_distros))
package_targets_arm64=$(addprefix package-, $(arm64_distros))
package_targets=${package_targets_amd64} ${package_targets_arm64}
packagetest_targets_amd64=$(addprefix package-test-, $(amd64_distros))
packagetest_targets_arm64=$(addprefix package-test-, $(arm64_distros))

test_targets=${dockertest_targets_amd64} ${dockertest_targets_arm64}
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
	echo "Copyright (c) 2025 Fabio Cicerchia. https://fabiocicerchia.it. MIT License"
	echo "Repo: https://github.com/$(GH_USERNAME)/nginx-lua"
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
		gsub("\\$$\\(build_targets\\)",              fix_value("$(build_targets)", $$2),              $$1); \
		gsub("\\$$\\(build_targets_amd64\\)",        fix_value("$(build_targets_amd64)", $$2),        $$1); \
		gsub("\\$$\\(build_targets_arm64\\)",        fix_value("$(build_targets_arm64)", $$2),        $$1); \
		gsub("\\$$\\(package_targets\\)",            fix_value("$(package_targets)", $$2),            $$1); \
		gsub("\\$$\\(package_targets_amd64\\)",      fix_value("$(package_targets_amd64)", $$2),      $$1); \
		gsub("\\$$\\(package_targets_arm64\\)",      fix_value("$(package_targets_arm64)", $$2),      $$1); \
		gsub("\\$$\\(packagetest_targets\\)",        fix_value("$(packagetest_targets)", $$2),        $$1); \
		gsub("\\$$\\(packagetest_targets_amd64\\)",  fix_value("$(packagetest_targets_amd64)", $$2),  $$1); \
		gsub("\\$$\\(packagetest_targets_arm64\\)",  fix_value("$(packagetest_targets_arm64)", $$2),  $$1); \
		gsub("\\$$\\(minimal_targets\\)",            fix_value("$(minimal_targets)", $$2),            $$1); \
		gsub("\\$$\\(test_targets\\)",               fix_value("$(test_targets)", $$2),               $$1); \
		gsub("\\$$\\(security_targets\\)",           fix_value("$(security_targets)", $$2),           $$1); \
		gsub("\\$$\\(push_targets\\)",               fix_value("$(push_targets)", $$2),               $$1); \
		gsub("\\$$\\(bundle_targets\\)",             fix_value("$(bundle_targets)", $$2),             $$1); \
		printf "  \033[36m%-50s\033[0m %s\n", $$1, $$2 \
	} /^##@/ { \
		printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	}' $(MAKEFILE_LIST)

################################################################################
##@ BUILD
################################################################################

build-all: build-amd64 build-arm64 ## build all dockerfiles
build-amd64: $(build_targets_amd64) ## build all distros in amd64 arch
build-arm64: $(build_targets_arm64) ## build all distros in arm64/v8 arch

$(build_targets_amd64): ## build one distro in amd64 arch
	TASK=$(@) $(MAKE) build-single

$(build_targets_arm64): ## build one distro in arm64/v8 arch
	TASK=$(@) $(MAKE) build-single

build-single: generate-dockerfiles
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
	return
endif
	ARCH=$(shell echo $$TASK | cut -d"-" -f2); \
	DISTRO=$(shell echo $$TASK | cut -d"-" -f3); \
	echo "BUILDING $$DISTRO"; \
	export DOCKER_CLI_EXPERIMENTAL=enabled; \
	$(BUILD_CMD) "$$DISTRO" "$$ARCH" && $(META_CMD) "$$DISTRO"

################################################################################
##@ TESTING
################################################################################

test-all: $(test_targets) ## test all docker images

$(test_targets): ## test one docker image
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
	return
endif
	ARCH=$(shell echo $(@) | sed -r 's/docker-test-(amd64|arm64v8)-.*/\1/'); \
	DISTRO=$(shell echo $(@) | sed -r 's/docker-test-(amd64|arm64v8)-//'); \
	echo "TESTING $$DISTRO"; \
	$(TEST_CMD) "$$DISTRO" "$$ARCH" "" "docker"

test-security: $(security_targets) ## test security all docker images

$(security_targets): ## test security one docker images
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
	return
endif
	DISTRO=$(subst test-security-,,$(@)); \
	echo "SECURITY $$DISTRO"; \
	$(SEC_CMD) "$$DISTRO"

################################################################################
##@ PUSH
################################################################################

push-all: $(push_targets) ## push all docker images to docker hub

$(push_targets): ## push one docker images to docker hub
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
	return
endif
	DISTRO=$(subst push-,,$(@)); \
	echo "PUSHING $$DISTRO"; \
	$(PUSH_CMD) "$$DISTRO"

################################################################################
##@ BUNDLE
################################################################################

$(bundle_targets): ## bundle multiple docker images into one
ifeq ($(SKIP), YES)
	echo "SKIPPING $@"
	return
endif
	DISTRO=$(subst bundle-,,$(@)); \
	echo "BUNDLING $$DISTRO"; \
	$(BUNDLE_CMD) "$$DISTRO"

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

packages: $(package_targets_amd64) $(package_targets_arm64) ## creating the system package .apk (Alpine), .deb (Debian-like), .rpm (RHEL-like)

$(package_targets_amd64): ## creating the system package in amd64 arch
	ARCH=amd64 DISTRO=$(subst package-amd64-,,$(@)) $(MAKE) .package-base

$(package_targets_arm64): ## creating the system package in arm64/v8 arch
	ARCH=arm64v8 DISTRO=$(subst package-arm64-,,$(@)) $(MAKE) .package-base

.package-base:
	./bin/package-base-nginx.sh "$(DISTRO)" "$(SUPPORTED_NGINX_VER_MAINLINE)" "$(ARCH)"
	./bin/package-base-nginx.sh "$(DISTRO)" "$(SUPPORTED_NGINX_VER_STABLE)" "$(ARCH)"

package-test: $(packagetest_targets_amd64) $(packagetest_targets_arm64) ## testing installation of the system package .apk (Alpine), .deb (Debian-like), .rpm (RHEL-like)

$(packagetest_targets_amd64): ## testing the system package in amd64 arch
	ARCH=amd64 DISTRO=$(subst package-test-amd64-,,$(@)) $(MAKE) .package-test-base

$(packagetest_targets_arm64): ## testing the system package in arm64/v8 arch
	ARCH=arm64v8 DISTRO=$(subst package-test-arm64-,,$(@)) $(MAKE) .package-test-base

.package-test-base:
	./bin/package-test-base.sh "$(DISTRO)" "$(SUPPORTED_NGINX_VER_MAINLINE)" "$(ARCH)"
	./bin/package-test-base.sh "$(DISTRO)" "$(SUPPORTED_NGINX_VER_STABLE)" "$(ARCH)"

################################################################################
##@ UTILITIES
################################################################################
auto-update: generate-supported-versions pull-nginx-entrypoints generate-deps-env generate-dockerfiles update-readme update-tags ## auto update supported versions, dockerfiles and tags

.setup_gitrepo:
	git config --global user.name "$(GH_USERNAME)"
	git config --global user.email "$(GH_USERNAME)@users.noreply.github.com"
	git remote set-url --push origin "https://$(GH_USERNAME):${GITHUB_TOKEN}@github.com/$(GH_USERNAME)/nginx-lua.git"

auto-update-and-commit: .setup_gitrepo auto-update
	git add -A || true; \
	CHANGES=$(git status | grep "Changes to be committed" | wc -l | tr -d ' '); \
	if [ "$$CHANGES" = "0" ]; then \
		exit 1; \
	fi; \
	git commit -m "Automated updates"; \
	git pull origin main || true; \
	git push origin main

auto-commit-metadata: .setup_gitrepo generate-metadata
	git add -A || true; \
	CHANGES=$(git status | grep "Changes to be committed" | wc -l | tr -d ' '); \
	if [ "$$CHANGES" != "0" ]; then \
		exit 1; \
	fi; \
	git commit -m "[ci skip] Automated metadata"; \
	git pull origin main || true; \
	git push origin main

release: ## create a github release
	mkdir -p dist && rm -rf dist/Dockerfile*
	cp Dockerfile dist/
	tail -n -6 supported_versions | tr '=' '/' | sed 's_^_nginx/$(SUPPORTED_NGINX_VER_MAINLINE)/_' | while read FOLDER; do \
		DOCKERFILE=$$(find $$FOLDER -name "Dockerfile"); \
		DEST="dist/$$(echo $$DOCKERFILE | sed 's_nginx/\(.*\)/\(.*\)/\(.*\)/\(Dockerfile.*\)_\4-nginx\1-\2\3_')"; \
		cp $$DOCKERFILE $$DEST; \
	done
	wget $(GH_CLI_TARBALL)
	tar xvzf $(GH_CLI_NAME).tar.gz
	if [ "$(shell git log --pretty=format:'- %B' $(PREVIOUS_TAG)..HEAD)" != "" ]; then \
		./$(GH_CLI_NAME)/ghr -b "$$(printf '%q' $$($(MAKE) --no-print-directory changelog))" $(TAG_VER) dist; \
	fi; \
	rm -rf dist

generate-supported-versions: ## generate supported_versions file
	./bin/generate-supported-versions.py

generate-dockerfiles: ## generate all dockerfiles
	./bin/generate-dockerfiles.py

generate-deps-env: ## generate .env for dependencies
	./bin/generate-deps-env.py | tee ./src/.env.dist

pull-nginx-entrypoints: ## retrieves the official entrypoint files (from mainline)
	USE_VERSION=master; \
	if [ "$$(curl --write-out '%{http_code}' --silent --output /dev/null $(NGINX_UPSTREAM_URL)/releases/tag/$(SUPPORTED_NGINX_VER_MAINLINE))" = "200" ]; then \
		USE_VERSION=$(SUPPORTED_NGINX_VER_MAINLINE); \
	fi; \
	curl -sLo src/10-listen-on-ipv6-by-default.sh $(NGINX_UPSTREAM_RAW_FILES)/$${USE_VERSION}/entrypoint/10-listen-on-ipv6-by-default.sh; \
	curl -sLo src/15-local-resolvers.envsh        $(NGINX_UPSTREAM_RAW_FILES)/$${USE_VERSION}/entrypoint/15-local-resolvers.envsh; \
	curl -sLo src/20-envsubst-on-templates.sh     $(NGINX_UPSTREAM_RAW_FILES)/$${USE_VERSION}/entrypoint/20-envsubst-on-templates.sh; \
	curl -sLo src/30-tune-worker-processes.sh     $(NGINX_UPSTREAM_RAW_FILES)/$${USE_VERSION}/entrypoint/30-tune-worker-processes.sh; \
	curl -sLo src/docker-entrypoint.sh            $(NGINX_UPSTREAM_RAW_FILES)/$${USE_VERSION}/entrypoint/docker-entrypoint.sh; \
	patch src/docker-entrypoint.sh src/docker-entrypoint.sh.patch

generate-metadata: ## generate metadata for all OS docker images
	echo $(DISTROS) | xargs -n1 $(META_CMD)

update-tags: ## update docker tags file
	./bin/generate_tags.py | tee docs/TAGS.md

update-readme: ## update supported docker tags in readme
	./bin/update-readme.sh

benchmark: ## benchmark (wip)
	./bin/benchmark.sh

changelog: ## generate a changelog since previous tag
	./bin/generate-changelog.sh "$(GH_USERNAME)" "$(PREVIOUS_TAG)" "$(TAG_VER)"