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

.PHONY: build
build: fmt lint docs ## Run format, lint and docs

.PHONY: lint
lint: lint/workflow lint/yaml ## Lint workflow files and YAML files

.PHONY: fmt
fmt: fmt/yaml ## Format YAML files

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
