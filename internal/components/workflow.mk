# Workflow
#
# Requirements:
# - Include `variables.mk`
#
# Usage:
#
# ```makefile
# -include $(COMPONENTS_DIR)/workflow.mk
# .PHONY: lint
# lint: lint/workflow
# ```

# Variables
ACTIONLINT ?= rhysd/actionlint:latest

# Targets
.PHONY: lint/workflow
lint/workflow: ### Lint workflow files
	@if [[ ! -d "$(ROOT_DIR)/.github/workflows" ]]; then printf "Skip: $@\n"; exit 0; fi; \
	printf "Run: \033[33m%-30s\033[0m %s\n" "$@"; \
	$(SECURE_DOCKER_RUN) $(ACTIONLINT) -color || true
