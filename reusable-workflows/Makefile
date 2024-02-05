# This option causes make to display a warning whenever an undefined variable is expanded.
MAKEFLAGS += --warn-undefined-variables

# Disable any builtin pattern rules, then speedup a bit.
MAKEFLAGS += --no-builtin-rules

# If this variable is not set, the program /bin/sh is used as the shell.
SHELL := /bin/bash

# The arguments passed to the shell are taken from the variable .SHELLFLAGS.
#
# The -e flag causes bash with qualifications to exit immediately if a command it executes fails.
# The -u flag causes bash to exit with an error message if a variable is accessed without being defined.
# The -o pipefail option causes bash to exit if any of the commands in a pipeline fail.
# The -c flag is in the default value of .SHELLFLAGS and we must preserve it.
# Because it is how make passes the script to be executed to bash.
.SHELLFLAGS := -eu -o pipefail -c

# Disable any builtin suffix rules, then speedup a bit.
.SUFFIXES:

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

# Variables: fundamentals
SELF_DIR ?= $(subst /Makefile,,$(lastword $(MAKEFILE_LIST)))
ROOT_DIR ?= $(shell $(GIT) rev-parse --show-toplevel)
RELEASE_WORKFLOW ?= _internal-release.yml

# Variables: commands
GIT ?= $(shell \command -v git 2>/dev/null)
GH ?= $(shell \command -v gh 2>/dev/null)
DOCKER ?= $(shell \command -v docker 2>/dev/null)
DOCKER_RUN ?= $(DOCKER) run $(DOCKER_OPTIONS)
SECURE_DOCKER_RUN ?= $(DOCKER_RUN) $(DOCKER_SECURE_OPTIONS)
DOCKER_OPTIONS ?=
DOCKER_OPTIONS += -it
DOCKER_OPTIONS += --rm
DOCKER_OPTIONS += -v $(ROOT_DIR):$(ROOT_DIR)
DOCKER_OPTIONS += -w $(ROOT_DIR)
DOCKER_SECURE_OPTIONS ?=
DOCKER_SECURE_OPTIONS += --read-only
DOCKER_SECURE_OPTIONS += --security-opt no-new-privileges
DOCKER_SECURE_OPTIONS += --cap-drop all
DOCKER_SECURE_OPTIONS += --network none

# Variables: container images
ACTIONLINT ?= $(SECURE_DOCKER_RUN) rhysd/actionlint:latest
YAMLLINT ?= $(SECURE_DOCKER_RUN) ghcr.io/tmknom/dockerfiles/yamllint:latest
PRETTIER ?= $(SECURE_DOCKER_RUN) ghcr.io/tmknom/dockerfiles/prettier:latest

# Targets: Build code
.PHONY: build
build: fmt lint ## Run format and lint

# Targets: Lint code
.PHONY: lint
lint: lint/workflow lint/yaml ## Lint workflow files and YAML files

.PHONY: lint/workflow
lint/workflow:
	$(ACTIONLINT) -color || true

.PHONY: lint/yaml
lint/yaml: internal/init/config
	$(YAMLLINT) --strict --config-file $(__MAKEFILES_CONFIG_DIR)/yamllint/reusable-workflows.yml . || true

# Targets: Format code
.PHONY: fmt
fmt: fmt/yaml ## Format YAML files

.PHONY: fmt/yaml
fmt/yaml:
	$(PRETTIER) --write --parser=yaml $(shell find . -name '*.y*ml')

# Targets: Release
.PHONY: release
release: ## Start release process
	@read -p "Bump up to (patch / minor / major): " answer && \
	case "$${answer}" in \
		'patch') make release/patch ;; \
		'minor') make release/minor ;; \
		'major') make release/major ;; \
		*) echo "Error: invalid parameter: $${answer}"; exit 1 ;; \
	esac && \
	make release/show

.PHONY: release/patch
release/patch:
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=patch

.PHONY: release/minor
release/minor:
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=minor

.PHONY: release/major
release/major:
	@read -p "Confirm major version upgrade? (y/N):" answer && \
	case "$${answer}" in \
	  [yY]*) $(GH) workflow run $(RELEASE_WORKFLOW) -f level=major ;; \
	  *) echo "Cancel major version upgrade." ;; \
	esac

.PHONY: release/show
release/show:
	@echo 'Starting release...'
	@sleep 5
	@id=$$($(GH) run list --limit 1 --json databaseId --jq '.[0].databaseId' --workflow $(RELEASE_WORKFLOW)) && \
	$(GH) run watch $${id}
	@sleep 1
	$(GH) release view --web

# Targets: help
.PHONY: help
help: ## Display help for all targets
	@grep --no-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Targets: Internal
.PHONY: internal/update
internal/update:
	cd $(ROOT_DIR)/$(SELF_DIR) && git stash && git switch main && git pull origin main

.PHONY: internal/update/self
internal/update/self:
	cd $(__MAKEFILES_FULL_ROOT_DIR) && git stash && git switch main && git pull origin main

# Variables: internal
__MAKEFILES_SELF ?= $(lastword $(MAKEFILE_LIST))
__MAKEFILES_SELF_DIR ?= $(subst /Makefile,,$(__MAKEFILES_SELF))
__MAKEFILES_ROOT_DIR ?= $(shell cut -d/ -f1 <<<$(__MAKEFILES_SELF))
__MAKEFILES_FULL_ROOT_DIR ?= $(ROOT_DIR)/$(__MAKEFILES_ROOT_DIR)

__MAKEFILES_IGNORE ?= .ignore
__MAKEFILES_IGNORE_DIR ?= $(__MAKEFILES_ROOT_DIR)/$(__MAKEFILES_IGNORE)
__MAKEFILES_FULL_IGNORE_DIR ?= $(ROOT_DIR)/$(__MAKEFILES_IGNORE_DIR)

__MAKEFILES_CONFIG ?= configurations
__MAKEFILES_CONFIG_DIR ?= $(__MAKEFILES_IGNORE_DIR)/$(__MAKEFILES_CONFIG)
__MAKEFILES_FULL_CONFIG_DIR ?= $(ROOT_DIR)/$(__MAKEFILES_CONFIG_DIR)
__MAKEFILES_CONFIG_REPO ?= https://github.com/tmknom/configurations.git

# Targets: Internal config
.PHONY: internal/init/config
internal/init/config: $(__MAKEFILES_CONFIG_DIR)/README.md
$(__MAKEFILES_CONFIG_DIR)/README.md:
	@git clone $(__MAKEFILES_CONFIG_REPO) $(__MAKEFILES_FULL_CONFIG_DIR) >/dev/null 2>&1

.PHONY: internal/update/config
internal/update/config: internal/init/config
	cd $(__MAKEFILES_FULL_CONFIG_DIR) && git stash && git switch main && git pull origin main
