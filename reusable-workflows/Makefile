# If this variable is not set, the program /bin/sh is used as the shell.
SHELL := /bin/bash

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

# Override variables
YAMLLINT_CONFIG ?= $(CONFIG_DIR)/yamllint/reusable-workflows.yml
RELEASE_WORKFLOW ?= _internal-release.yml

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
build: fmt lint ## Run format and lint

.PHONY: lint
lint: lint/workflow lint/yaml lint/shell ## Lint workflow files, YAML files and shell files

.PHONY: fmt
fmt: fmt/yaml fmt/shell ## Format YAML files and shell files

# Targets: Release
-include $(COMPONENTS_DIR)/release.mk
.PHONY: release
release: release/start ## Start release process

# Targets: Internal
-include $(COMPONENTS_DIR)/internal.mk
