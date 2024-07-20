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

.PHONY: multi/stash
multi/stash: ### Stash to main branch for multiple repositories
	$(ROOT_DIR)/internal/scripts/admin/stash.sh

.PHONY: multi/copy
multi/copy: ### Copy file for multiple repositories
	@read -p "Which source file to copy? (ex: src.md): " src && \
	read -p "Which source file to copy? (ex: dest.md): " dest && \
	$(ROOT_DIR)/internal/scripts/admin/copy.sh "$${src}" "$${dest}"

.PHONY: multi/commit
multi/commit: ### Commit all files for multiple repositories
	@read -p "Which branch to commit? (ex: feat/foo-bar): " branch && \
	read -p "What message do you want to commit? (ex: add feature): " message && \
	$(ROOT_DIR)/internal/scripts/admin/commit.sh "$${branch}" "$${message}"

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
