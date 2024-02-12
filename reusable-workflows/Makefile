# If this variable is not set, the program /bin/sh is used as the shell.
SHELL := /bin/bash

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

# Override variables
YAMLLINT_CONFIG ?= $(CONFIG_DIR)/yamllint/reusable-workflows.yml
TEST_WORKFLOW ?= _internal-test.yml
RELEASE_WORKFLOW ?= _internal-release.yml

# Include initial components
COMPONENTS_DIR := $(shell cut -d/ -f1 <<<$(lastword $(MAKEFILE_LIST)))/internal/components
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
build: fmt lint ## Run format and lint

.PHONY: lint
lint: lint/workflow lint/yaml lint/shell ## Lint workflow files, YAML files and shell files

.PHONY: fmt
fmt: fmt/yaml fmt/shell ## Format YAML files and shell files

# Targets: Test
-include $(COMPONENTS_DIR)/test.mk
.PHONY: test
test: test/run ## Test at workflow

# Targets: Release
-include $(COMPONENTS_DIR)/release.mk
.PHONY: release
release: release/run ## Start release process

# Targets: Internal
-include $(COMPONENTS_DIR)/internal.mk
