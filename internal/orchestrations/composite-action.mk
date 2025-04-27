# If this variable is not set, the program /bin/sh is used as the shell.
SHELL := /bin/bash

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

# Override variables
YAMLLINT_CONFIG ?= $(CONFIG_DIR)/yamllint/composite-action.yml
TEST_WORKFLOW ?= test.yml
RELEASE_WORKFLOW ?= release.yml

# Include initial components
COMPONENTS_DIR := ${XDG_DATA_HOME}/makefiles/internal/components
include $(COMPONENTS_DIR)/flags.mk
include $(COMPONENTS_DIR)/variables.mk

# Targets: Help
-include $(COMPONENTS_DIR)/help.mk
.PHONY: help
help: help/primary ## Display help (details: make help/all)

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
-include $(COMPONENTS_DIR)/test.mk
.PHONY: test
test: test/run ## Test at workflow

# Targets: Generate document
ACTDOCS ?= ghcr.io/tmknom/actdocs:latest
.PHONY: docs
docs: ## Generate documentation for README
	$(SECURE_DOCKER_RUN) $(ACTDOCS) inject --sort --file=README.md action.yml

# Targets: Release
-include $(COMPONENTS_DIR)/release.mk
.PHONY: release
release: release/run ## Start release process

# Targets: Internal
-include $(COMPONENTS_DIR)/internal.mk
