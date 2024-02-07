# If this variable is not set, the program /bin/sh is used as the shell.
SHELL := /bin/bash

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

# Override variables
YAMLLINT_CONFIG ?= $(CONFIG_DIR)/yamllint/composite-action.yml
RELEASE_WORKFLOW ?= release.yml

# Include initial components
COMPONENTS_DIR := $(shell cut -d/ -f1 <<<$(lastword $(MAKEFILE_LIST)))/internal/components
include $(COMPONENTS_DIR)/flags.mk
include $(COMPONENTS_DIR)/variables.mk

# Targets: Help
-include $(COMPONENTS_DIR)/help.mk
.PHONY: help
help: help/primary ## Display help for primary targets

# Targets: Build
-include $(COMPONENTS_DIR)/workflow.mk
-include $(COMPONENTS_DIR)/yaml.mk
-include $(COMPONENTS_DIR)/shell.mk

.PHONY: build
build: fmt lint docs ## Run format, lint and docs

.PHONY: lint
lint: lint/workflow lint/yaml lint/shell ## Lint workflow files, YAML files and shell files

.PHONY: fmt
fmt: fmt/yaml fmt/shell ## Format YAML files and shell files

# Targets: Test
TEST_WORKFLOW ?= test.yml
CURRENT_BRANCH ?= $(shell $(GIT) rev-parse --abbrev-ref HEAD)
.PHONY: test
test: ## Run test workflow
	if [[ "$(CURRENT_BRANCH)" != "main" ]]; then \
		echo "Push: $(CURRENT_BRANCH)"; \
		$(GIT) push origin $(CURRENT_BRANCH) --force 2>/dev/null; \
	fi
	$(GH) workflow run $(TEST_WORKFLOW) --ref $(CURRENT_BRANCH)
	sleep 2
	id=$$($(GH) run list --limit 1 --json databaseId --jq '.[0].databaseId' --workflow $(TEST_WORKFLOW)) && \
	$(GH) run watch $${id} && \
	$(GH) run view --log-failed $${id}

# Targets: Generate document
ACTDOCS ?= ghcr.io/tmknom/actdocs:latest
.PHONY: docs
docs: ## Generate documentation for README
	$(SECURE_DOCKER_RUN) $(ACTDOCS) inject --sort --file=README.md action.yml

# Targets: Release
-include $(COMPONENTS_DIR)/release.mk
.PHONY: release
release: release/start ## Start release process

# Targets: Internal
-include $(COMPONENTS_DIR)/internal.mk
