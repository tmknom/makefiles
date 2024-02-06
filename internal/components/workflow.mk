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
	$(SECURE_DOCKER_RUN) $(ACTIONLINT) -color || true
