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
# release: release/run
# ```

# Override variables
RELEASE_WORKFLOW ?= release.yml

# Targets
.PHONY: release/run
release/run: ### Run release workflow
	@read -p "Bump up to (patch / minor / major): " answer && \
	case "$${answer}" in \
		'patch') make release/patch ;; \
		'minor') make release/minor ;; \
		'major') make release/major ;; \
		*) echo "Error: invalid parameter: $${answer}"; exit 1 ;; \
	esac

.PHONY: release/patch
release/patch: ### Release patch version
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=patch || true
	make release/show

.PHONY: release/minor
release/minor: ### Release minor version
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=minor || true
	make release/show

.PHONY: release/major
release/major: ### Release major version
	@read -p "Confirm major version upgrade? (y/N):" answer && \
	case "$${answer}" in \
	  [yY]*) $(GH) workflow run $(RELEASE_WORKFLOW) -f level=major; make release/show ;; \
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
