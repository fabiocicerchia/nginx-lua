#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2023 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

PAGER:=
DOCKERFILE_CHANGES=$(shell (git fetch origin main > /dev/null; git diff-tree --no-commit-id --name-only -r origin/main) | egrep "(nginx|src)/" | wc -l | tr -d ' ')
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
	ARCH=$(shell echo $$TASK | cut -d"-" -f2); \
	DISTRO=$(subst test-,,$(@)); \
	echo "TESTING $$DISTRO"; \
	$(TEST_CMD) "$$DISTRO" "$$ARCH" "" "docker"
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

packages: $(package_targets_amd64) $(package_targets_arm64) ## creating the system package .apk (Alpine), .deb (Debian-like), .rpm (RHEL-like)

$(package_targets_amd64): ## creating the system package in amd64 arch
	ARCH=amd64 DISTRO=$(subst package-amd64-,,$(@)) $(MAKE) .package-base

$(package_targets_arm64): ## creating the system package in arm64/v8 arch
	ARCH=arm64v8 DISTRO=$(subst package-arm64-,,$(@)) $(MAKE) .package-base

.package-base:
	if [ "$(DISTRO)" = "alpine" ]; then \
		PACKAGE_TYPE=apk; \
	elif [ "$(DISTRO)" = "almalinux" -o "$(DISTRO)" = "amazonlinux" -o "$(DISTRO)" = "fedora" ]; then \
		PACKAGE_TYPE=rpm; \
	elif [ "$(DISTRO)" = "debian" -o "$(DISTRO)" = "ubuntu" ]; then \
		PACKAGE_TYPE=deb; \
	fi; \
	SUPPORTED_NGINX_VER=$(SUPPORTED_NGINX_VER); \
	if [ "$${IMAGE_ID}" != "" ]; then \
		SUPPORTED_NGINX_VER=1; \
	fi; \
	mkdir dist; \
	docker build \
		-f src/packages/Dockerfile.$$PACKAGE_TYPE \
		-t package-nginx-$$PACKAGE_TYPE \
		--build-arg ARCH="$(ARCH)" \
		--build-arg NGINX_VERSION="$${SUPPORTED_NGINX_VER}" \
		--build-arg DISTRO="$(DISTRO)" \
		--build-arg OS_VERSION="$(OS_VER)" \
		--build-arg FPM_OUTPUT_TYPE="$$PACKAGE_TYPE" \
		src/packages; \
	docker rm -f extract-$$PACKAGE_TYPE || true; \
	docker run -d --name extract-$$PACKAGE_TYPE package-nginx-$$PACKAGE_TYPE && \
	docker exec extract-$$PACKAGE_TYPE sh -c "ls -1 /nginx-lua*.$$PACKAGE_TYPE"; \
	docker cp extract-$$PACKAGE_TYPE:$$(docker exec extract-$$PACKAGE_TYPE sh -c "ls -1 /nginx-lua*.$$PACKAGE_TYPE") dist/; \
	docker rm -f extract-$$PACKAGE_TYPE

package-test: $(packagetest_targets_amd64) $(packagetest_targets_arm64) ## testing installation of the system package .apk (Alpine), .deb (Debian-like), .rpm (RHEL-like)

$(packagetest_targets_amd64): ## testing the system package in amd64 arch
	ARCH=amd64 DISTRO=$(subst package-test-amd64-,,$(@)) $(MAKE) .package-test-base

$(packagetest_targets_arm64): ## testing the system package in arm64/v8 arch
	ARCH=arm64v8 DISTRO=$(subst package-test-arm64-,,$(@)) $(MAKE) .package-test-base

.package-test-base:
	if [ "$(DISTRO)" = "alpine" ]; then \
		PACKAGE_TYPE=apk; \
		INSTALL_CMD="apk add -v --allow-untrusted /app/*_noarch.apk"; \
	elif [ "$(DISTRO)" = "almalinux" -o "$(DISTRO)" = "amazonlinux" -o "$(DISTRO)" = "fedora" ]; then \
		PACKAGE_TYPE=rpm; \
		INSTALL_CMD="yum localinstall -y /app/*_x86_64.rpm"; \
		if [ "$(ARCH)" = "arm64" ]; then \
			INSTALL_CMD="yum localinstall -y /app/*.aarch64.rpm"; \
		fi; \
	elif [ "$(DISTRO)" = "debian" -o "$(DISTRO)" = "ubuntu" ]; then \
		PACKAGE_TYPE=deb; \
		INSTALL_CMD="apt update && apt install -yf /app/*_$(ARCH).deb"; \
	fi; \
	docker rm -f test-$$PACKAGE_TYPE || true; \
	docker run --name test-$$PACKAGE_TYPE -v $$PWD/dist:/app -d $(DISTRO):latest sleep infinity; \
	docker exec test-$$PACKAGE_TYPE /bin/sh -c "ls -lah /app"; \
	docker exec test-$$PACKAGE_TYPE /bin/sh -c "$$INSTALL_CMD"; \
	docker exec test-$$PACKAGE_TYPE /bin/sh -c "envsubst -V \
		&& nginx -V \
		&& nginx -t \
		&& luajit -v \
		&& lua -v \
		&& luarocks --version"; \
	docker rm -f test-$$PACKAGE_TYPE
	$(TEST_CMD) "$(DISTRO)" "$(ARCH)" "" "package"

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
		git commit -m "[ci skip] Automated updates"; \
		git pull origin main || true; \
		git push origin main; \
	else \
		exit 1; \
	fi

auto-commit-metadata: .setup_gitrepo generate-metadata
	git add -A || true; \
	CHANGES=$(git status | grep "Changes to be committed" | wc -l | tr -d ' '); \
	if [ "$$CHANGES" != "0" ]; then \
		git commit -m "[ci skip] Automated metadata"; \
		git pull origin main || true; \
		git push origin main; \
	else \
		exit 1; \
	fi

release: ## create a github release
	mkdir -p dist && rm -rf dist/Dockerfile*
	cp Dockerfile dist/
	tail -n -6 supported_versions | tr '=' '/' | sed 's_^_nginx/$(SUPPORTED_NGINX_VER)/_' | xargs find | grep Dockerfile | while read file; do cp $$file dist/$$(echo $$file | sed 's_nginx/\(.*\)/\(.*\)/\(.*\)/\(Dockerfile.*\)_\4-nginx\1-\2\3_'); done
	wget https://github.com/tcnksm/ghr/releases/download/v0.16.2/ghr_v0.16.2_linux_amd64.tar.gz
	tar xvzf ghr_v0.16.2_linux_amd64.tar.gz
	if [ "$(shell git log --pretty=format:'- %B' $(PREVIOUS_TAG)..HEAD)" != "" ]; then \
		./ghr_v0.16.2_linux_amd64/ghr -b "$$(printf '%q' $$($(MAKE) --no-print-directory changelog))" $(TAG_VER) dist; \
	fi

generate-supported-versions: ## generate supported_versions file
	./bin/generate-supported-versions.sh

generate-dockerfiles: ## generate all dockerfiles
	./bin/generate-dockerfiles.py

pull-nginx-entrypoints: ## retrieves the official entrypoint files
	curl -sLo src/10-listen-on-ipv6-by-default.sh https://raw.githubusercontent.com/nginxinc/docker-nginx/$(SUPPORTED_NGINX_VER)/entrypoint/10-listen-on-ipv6-by-default.sh
	curl -sLo src/15-local-resolvers.envsh https://raw.githubusercontent.com/nginxinc/docker-nginx/$(SUPPORTED_NGINX_VER)/entrypoint/15-local-resolvers.envsh
	curl -sLo src/20-envsubst-on-templates.sh https://raw.githubusercontent.com/nginxinc/docker-nginx/$(SUPPORTED_NGINX_VER)/entrypoint/20-envsubst-on-templates.sh
	curl -sLo src/30-tune-worker-processes.sh https://raw.githubusercontent.com/nginxinc/docker-nginx/$(SUPPORTED_NGINX_VER)/entrypoint/30-tune-worker-processes.sh
	curl -sLo src/docker-entrypoint.sh https://raw.githubusercontent.com/nginxinc/docker-nginx/$(SUPPORTED_NGINX_VER)/entrypoint/docker-entrypoint.sh
	patch src/docker-entrypoint.sh src/docker-entrypoint.sh.patch

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
