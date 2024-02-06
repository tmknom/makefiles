# Override variables only this repository
MAKEFILES_SELF ?= .
COMPONENTS_DIR ?= internal/components

# Include: minimum
YAMLLINT_CONFIG ?= $(CONFIG_DIR)/yamllint/github-actions.yml
RELEASE_WORKFLOW ?= release.yml
-include minimum/Makefile

# Targets: Build
.PHONY: build
build: fmt lint ## Run format and lint

.PHONY: lint
lint: lint/workflow lint/yaml lint/shell ## Lint workflow files and YAML files

.PHONY: fmt
fmt: fmt/yaml fmt/shell ## Format YAML files

# Targets: Release
.PHONY: release
release: release/start ## Start release process
