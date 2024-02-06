# Release
#
# Requirements:
# - Include `variables.mk`
#
# Usage:
#
# ```makefile
# RELEASE_WORKFLOW ?= release.yml
# -include $(COMPONENTS_DIR)/release.mk
# .PHONY: release
# release: release/start
# ```

# Override variables
RELEASE_WORKFLOW ?=

# Variables
GH ?= $(shell \command -v gh 2>/dev/null)

# Targets
.PHONY: release/start
release/start:
	@read -p "Bump up to (patch / minor / major): " answer && \
	case "$${answer}" in \
		'patch') make release/patch ;; \
		'minor') make release/minor ;; \
		'major') make release/major ;; \
		*) echo "Error: invalid parameter: $${answer}"; exit 1 ;; \
	esac && \
	make release/show

.PHONY: release/patch
release/patch:
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=patch

.PHONY: release/minor
release/minor:
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=minor

.PHONY: release/major
release/major:
	@read -p "Confirm major version upgrade? (y/N):" answer && \
	case "$${answer}" in \
	  [yY]*) $(GH) workflow run $(RELEASE_WORKFLOW) -f level=major ;; \
	  *) echo "Cancel major version upgrade." ;; \
	esac

.PHONY: release/show
release/show:
	@echo 'Starting release...'
	@sleep 5
	@id=$$($(GH) run list --limit 1 --json databaseId --jq '.[0].databaseId' --workflow $(RELEASE_WORKFLOW)) && \
	$(GH) run watch $${id}
	@sleep 1
	$(GH) release view --web
