# Override variables only this repository
MAKEFILES_SELF ?= .
COMPONENTS_DIR ?= internal/components

# Include: minimum
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
release: release/run ## Start release process

# Targets: Admin
.PHONY: update
update: ## Update makefiles for all repositories
	$(ROOT_DIR)/internal/scripts/admin/update.sh

.PHONY: multi/push
multi/push: ### Push to specify branch for multiple repositories
	@read -p "Which branch to push changes? (ex: feat/foo-bar): " branch && \
	$(ROOT_DIR)/internal/scripts/admin/push.sh "$${branch}"

.PHONY: multi/pull
multi/pull: ### Pull main branch for multiple repositories
	$(ROOT_DIR)/internal/scripts/admin/pull.sh

.PHONY: multi/exec
multi/exec: ### Execute commands for multiple repositories
	@read -p "What command do you want to run? (ex: ls -a): " commands && \
	$(ROOT_DIR)/internal/scripts/admin/exec.sh "$${commands}"
