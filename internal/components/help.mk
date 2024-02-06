# Help
#
# Usage:
#
# ```makefile
# -include $(COMPONENTS_DIR)/help.mk
# .PHONY: help
# help: help/primary
# ```

# Targets
.PHONY: help/primary
help/primary:
	@grep --no-filename -E '^[a-zA-Z0-9_/-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| grep -v '###' | sort -u \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
