PAGER=
PREVIOUS_TAG=$(shell git ls-remote --tags 2>&1 | awk '{print $$2}' | sort -r | head -n 1 | cut -d "/" -f3)
DOCKERFILE_CHANGES=$(shell git diff-tree --no-commit-id --name-only -r HEAD nginx tpl | wc -l | tr -d ' ')
ifeq ($(DOCKERFILE_CHANGES), 0)
	SKIP=1
else
	SKIP=0
endif
ifeq ($(FORCE), 1)
	SKIP=0
endif
BUILD_CMD=./bin/docker-build.sh
PUSH_CMD=./bin/docker-push.sh
TEST_CMD=./bin/test.sh
SEC_CMD=./bin/test-security.sh
META_CMD=./bin/docker-metadata.sh
TAG_VER=$(shell date +'v1.%Y%m%d.%H%M%S')
CHANGELOG=$(shell make changelog)
DISTROS=alpine amazonlinux centos debian fedora ubuntu

build_targets=$(addprefix build-, $(DISTROS))
test_targets=$(addprefix test-, $(DISTROS))
push_targets=$(addprefix push-, $(DISTROS))
security_targets=$(addprefix test-security-, $(DISTROS))
minimal_targets=$(addprefix build-minimal-, $(DISTROS))

.PHONY: changelog
.SILENT: help changelog

################################################################################
# HELP
################################################################################
default: help

help:
	echo "UTILITIES"
	echo " - tag"
	echo " - release"
	echo " - auto-update"
	echo "   - generate-supported-versions"
	echo "   - generate-dockerfiles"
	echo "   - update-tags"
	echo " - generate-metadata"
	echo " - update-readme"
	echo " - benchmark"
	echo " - changelog"

	echo "ALL: build-all test-all push-all"

	echo "BUILD"
	echo " - build-all"
	echo "   - build-alpine"
	echo "   - build-amazonlinux"
	echo "   - build-centos"
	echo "   - build-debian"
	echo "   - build-fedora"
	echo "   - build-ubuntu"

	echo "BUILD MINIMAL"
	echo " - build-minimal-all"
	echo "   - build-minimal-alpine"
	echo "   - build-minimal-amazonlinux"
	echo "   - build-minimal-centos"
	echo "   - build-minimal-debian"
	echo "   - build-minimal-fedora"
	echo "   - build-minimal-ubuntu"

	echo "TESTING"
	echo " - test-all"
	echo "   - test-alpine"
	echo "   - test-amazonlinux"
	echo "   - test-centos"
	echo "   - test-debian"
	echo "   - test-fedora"
	echo "   - test-ubuntu"

	echo "LINTING"
	echo " - test-lint"

	echo "SECURITY"
	echo " - test-security"
	echo "   - test-security-alpine"
	echo "   - test-security-amazonlinux"
	echo "   - test-security-centos"
	echo "   - test-security-debian"
	echo "   - test-security-fedora"
	echo "   - test-security-ubuntu"

	echo "PUSHING"
	echo "  - push-all"
	echo "    - push-alpine"
	echo "    - push-amazonlinux"
	echo "    - push-centos"
	echo "    - push-debian"
	echo "    - push-fedora"
	echo "    - push-ubuntu"

################################################################################
# UTILITIES
################################################################################
auto-update: generate-supported-versions generate-dockerfiles update-tags

.setup_gitrepo:
	git config --global user.name "fabiocicerchia"
	git config --global user.email "fabiocicerchia@users.noreply.github.com"
	git remote set-url --push origin "https://fabiocicerchia:${GH_TOKEN}@github.com/fabiocicerchia/nginx-lua.git"

auto-update-and-commit: .setup_gitrepo auto-update
	git add -A
	git commit -m "Automated updates"
	git push origin HEAD:master

auto-commit-metadata: .setup_gitrepo generate-metadata
	git add -A
	git commit -m "Automated metadata" || true
	git push origin HEAD:master

tag: .setup_gitrepo
	git tag $(TAG_VER) -a -m "$(TAG_VER)"
	git push origin --tags

release:
	curl --data '{"tag_name": "$(TAG_VER)", "target_commitish": "master", "name": "$(TAG_VER)", "body": "$(CHANGELOG)", "draft": false, "prerelease": false}' \
		https://api.github.com/repos/fabiocicerchia/nginx-lua/releases?access_token=$(GH_TOKEN)

generate-supported-versions:
	./bin/generate-supported-versions.sh

generate-dockerfiles:
	./bin/generate-dockerfiles.sh

generate-metadata:
	for DISTRO in $(DISTROS); do \
		$(META_CMD) $$DISTRO 0; \
	done

update-tags:
	./bin/generate_tags.py | tee docs/TAGS.md

update-readme:
	./bin/update-readme.sh

benchmark:
	./bin/benchmark.sh

changelog:
	git fetch --all --tags
	echo "Changes:"
	git log --pretty=format:"- %B" $(PREVIOUS_TAG)..HEAD | tr '\r' '\n' | grep -Ev '^$$' > CHANGELOG
	sed -i "" 's/^*/-/' CHANGELOG
	sed -i "" 's/^[ \t]*//' CHANGELOG
	sed -i "" 's/^-[ \t]*//' CHANGELOG
	sed -i "" 's/^-[ \t]*//' CHANGELOG
	sed -i "" 's/^/ - /' CHANGELOG
	cat CHANGELOG
	echo ""
	echo "Supported Versions:"
	cat supported_versions | sed 's/[()"]//g' | tr 'A-Z' 'a-z' | sed 's/^/ - /'

################################################################################
# GENERIC
################################################################################

all: build-all test-all push-all

################################################################################
# BUILD
################################################################################

build-all: $(build_targets)

$(build_targets):
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst build-,,$(@)); \
	echo BUILDING $$DISTRO; \
	$(BUILD_CMD) $$DISTRO 1; \
	$(META_CMD) $$DISTRO 1
endif

################################################################################
# BUILD MINIMAL
################################################################################

build-minimal-all: $(minimal_targets)

$(minimal_targets):
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst build-minimal-,,$(@)); \
	echo BUILDING $$DISTRO; \
	$(BUILD_CMD) $$DISTRO 1 0
endif

################################################################################
# TESTING
################################################################################

test-all: $(test_targets)

$(test_targets):
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst test-,,$(@)); \
	echo TESTING $$DISTRO; \
	$(TEST_CMD) $$DISTRO 1
endif

test-security: $(security_targets)

$(security_targets):
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst test-security-,,$(@)); \
	echo SECURITY $$DISTRO; \
	$(SEC_CMD) $$DISTRO
endif

################################################################################
# PUSH
################################################################################

push-all: $(push_targets)

$(push_targets):
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst push-,,$(@)); \
	echo PUSHING $$DISTRO; \
	$(TEST_CMD) $$DISTRO 1
endif