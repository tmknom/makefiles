# Test
#
# Requirements:
# - Include `variables.mk`
#
# Usage:
#
# ```makefile
# TEST_WORKFLOW ?= test.yml
# -include $(COMPONENTS_DIR)/test.mk
# .PHONY: test
# test: test/run
# ```

# Override variables
TEST_WORKFLOW ?= test.yml
CURRENT_BRANCH ?= $(shell $(GIT) rev-parse --abbrev-ref HEAD)
DEFAULT_BRANCH ?= $(shell $(GH) repo view --json=defaultBranchRef --jq=.defaultBranchRef.name)

# Targets
.PHONY: test/run
test/run: ### Run test workflow
	@if [[ "$(CURRENT_BRANCH)" != "$(DEFAULT_BRANCH)" ]]; then \
		echo "Push: $(CURRENT_BRANCH)"; \
		$(GIT) push origin $(CURRENT_BRANCH) --force-with-lease --force-if-includes 2>/dev/null; \
	fi
	$(GH) workflow run $(TEST_WORKFLOW) --ref $(CURRENT_BRANCH)
	@sleep 2
	@id=$$($(GH) run list --limit 1 --json databaseId --jq '.[0].databaseId' --workflow $(TEST_WORKFLOW)) && \
	$(GH) run watch $${id} && \
	$(GH) run view --log-failed $${id}
