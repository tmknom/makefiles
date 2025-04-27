# If this variable is not set, the program /bin/sh is used as the shell.
SHELL := /bin/bash

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

# Override variables
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
-include $(COMPONENTS_DIR)/go.mk

.PHONY: deps
deps: deps/go ## Install Go modules

.PHONY: build
build: build/go ## Build executable binary

.PHONY: test
test: test/go ## Test Go

.PHONY: lint
lint: lint/go lint/workflow lint/yaml lint/shell ## Lint Go, workflow, YAML, and shell files

.PHONY: prepare
prepare: prepare/go ## Prepare Go projects

.PHONY: fmt
fmt: fmt/yaml fmt/shell ## Format YAML files and shell files

# Targets: Release
-include $(COMPONENTS_DIR)/release.mk
.PHONY: release
release: release/run ## Start release process

# Targets: Internal
-include $(COMPONENTS_DIR)/internal.mk
