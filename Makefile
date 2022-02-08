#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2022 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

PAGER:=
DOCKERFILE_CHANGES=$(shell (git fetch origin main > /dev/null; git diff-tree --no-commit-id --name-only -r origin/main) | egrep "(nginx|tpl)/" | wc -l | tr -d ' ')
ifeq ($(DOCKERFILE_CHANGES), 0)
	SKIP=1
else
	SKIP=0
endif
ifeq ($(FORCE), 1)
	SKIP=0
endif
BUILD_CMD:=./bin/docker-build.sh
PUSH_CMD:=./bin/docker-push.sh
TEST_CMD:=./bin/test.sh
SEC_CMD:=./bin/test-security.sh
META_CMD:=./bin/docker-metadata.sh
DISTROS=almalinux alpine amazonlinux debian fedora ubuntu

PREVIOUS_TAG=$(shell git ls-remote --tags 2>&1 | awk '{print $$2}' | sort -r | head -n 1 | cut -d "/" -f3)
TAG_VER=$(shell date +'v1.%Y%m%d.%H%M%S')
CHANGELOG=$(shell make changelog)

build_targets=$(addprefix build-, $(DISTROS))
test_targets=$(addprefix test-, $(DISTROS))
push_targets=$(addprefix push-, $(DISTROS))
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
	echo "Copyright (c) 2022 Fabio Cicerchia. https://fabiocicerchia.it. MIT License"
	echo "Repo: https://github.com/fabiocicerchia/nginx-lua"
	echo ""
	@gawk 'function fix_value(value, str) { \
		padding=sprintf("%30s",""); \
		ret=gensub("([^ ]+)", "\\1"padding"\n ", "g", "  "value); \
		ret=gensub("(^|\n)(.{33}) *", "\\1\\2\033[0m"str"  \033[36m", "g", ret); \
		ret=substr(ret, 3, length(ret)-16-length(str)); \
		return ret; \
	} \
	BEGIN { \
		FS = ":.*##"; \
		printf "Use: make \033[36m<target>\033[0m\n"; \
	} /^\$$?\(?[a-zA-Z_-]+\)?:.*?##/ { \
		gsub("\\$$\\(build_targets\\)",    fix_value("$(build_targets)", $$2),    $$1); \
		gsub("\\$$\\(minimal_targets\\)",  fix_value("$(minimal_targets)", $$2),  $$1); \
		gsub("\\$$\\(test_targets\\)",     fix_value("$(test_targets)", $$2),     $$1); \
		gsub("\\$$\\(security_targets\\)", fix_value("$(security_targets)", $$2), $$1); \
		gsub("\\$$\\(push_targets\\)",     fix_value("$(push_targets)", $$2),     $$1); \
		printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 \
	} /^##@/ { \
		printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	}' $(MAKEFILE_LIST)

################################################################################
##@ BUILD
################################################################################

build-all: $(build_targets) ## build all dockerfiles

$(build_targets): ## build one distro
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst build-,,$(@)); \
	echo BUILDING $$DISTRO; \
	$(BUILD_CMD) $$DISTRO 1; \
	$(META_CMD) $$DISTRO 1
endif

################################################################################
##@ BUILD MINIMAL
################################################################################

build-minimal-all: $(minimal_targets) ## build all dockerfiles (minimal)

$(minimal_targets): ## build one distro (minimal)
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst build-minimal-,,$(@)); \
	echo BUILDING $$DISTRO; \
	$(BUILD_CMD) $$DISTRO 1 0
endif

################################################################################
##@ TESTING
################################################################################

test-all: $(test_targets) ## test all docker images

$(test_targets): ## test one docker image
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst test-,,$(@)); \
	echo TESTING $$DISTRO; \
	$(TEST_CMD) $$DISTRO 1
endif

test-security: $(security_targets) ## test security all docker images

$(security_targets): ## test security one docker images
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst test-security-,,$(@)); \
	echo SECURITY $$DISTRO; \
	$(SEC_CMD) $$DISTRO
endif

################################################################################
##@ PUSH
################################################################################

push-all: $(push_targets) ## push all docker images to docker hub

$(push_targets): ## push one docker images to docker hub
ifeq ($(SKIP), 1)
	echo SKIPPING $@
else
	DISTRO=$(subst push-,,$(@)); \
	echo PUSHING $$DISTRO; \
	$(PUSH_CMD) $$DISTRO 1
endif

################################################################################
##@ UTILITIES
################################################################################
auto-update: generate-supported-versions generate-dockerfiles update-readme update-tags ## auto update supported versions, dockerfiles and tags

.setup_gitrepo:
	git config --global user.name "fabiocicerchia"
	git config --global user.email "fabiocicerchia@users.noreply.github.com"
	git remote set-url --push origin "https://fabiocicerchia:${GH_TOKEN}@github.com/fabiocicerchia/nginx-lua.git"

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

tag: .setup_gitrepo ## create a git tag
	git tag $(TAG_VER) -a -m "$(TAG_VER)"
	git push origin --tags

release: ## create a github release
	echo '{"tag_name": "${TAG_VER}", "target_commitish": "main", "name": "${TAG_VER}", "body": "' > BODY.json
	make changelog >> BODY.json
	echo '", "draft": false, "prerelease": false}' >> BODY.json
	cat BODY.json | sed -e ':a' -e 'N' -e '$$!ba' -e 's/\n/\\n/g' | tee BODY.json
	curl --data-binary @BODY.json \
		"https://api.github.com/repos/fabiocicerchia/nginx-lua/releases?access_token=${GH_TOKEN}"

generate-supported-versions: ## generate supported_versions file
	./bin/generate-supported-versions.sh

generate-dockerfiles: ## generate all dockerfiles
	./bin/generate-dockerfiles.sh

generate-metadata: ## generate all metadata for docker images
	for DISTRO in $(DISTROS); do \
		$(META_CMD) $$DISTRO 0; \
	done

update-tags: ## update docker tags file
	./bin/generate_tags.py | tee docs/TAGS.md

update-readme: ## update supported docker tags in readme
	./bin/update-readme.sh

benchmark: ## benchmark (wip)
	./bin/benchmark.sh

changelog: ## generate a changelog since previous tag
	git fetch --all --tags > /dev/null
	echo "Changes:"
	git log --pretty=format:"- %B" $(PREVIOUS_TAG)..HEAD | tr '\r' '\n' | grep -Ev '^$$' || :; > CHANGELOG
	cat CHANGELOG | egrep -v "Automated (metadata|updates)" | sed -e 's/^*/-/' -e 's/"/\\"/g' -e 's/^[ \t]*//' -e 's/^-[ \t]*//' -e 's/^-[ \t]*//' -e 's/^/ - /' | awk '!x[$$0]++' | tee CHANGELOG
	echo ""
	echo "Supported Versions:"
	cat supported_versions | sed 's/[()"]//g' | tr 'A-Z' 'a-z' | sed 's/^/ - /'
