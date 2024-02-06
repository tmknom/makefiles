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
.PHONY: help/all
help/all: ### Display help for all targets
	@echo "Primary targets"
	@make help/primary
	@echo ""
	@echo "Secondary targets"
	@make help/secondary

.PHONY: help/primary
help/primary:
	@grep --no-filename -E '^[a-zA-Z0-9_/-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| grep -v '###' | sort -u \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help/secondary
help/secondary:
	@grep --no-filename -E '^[a-zA-Z0-9_/-]+:.*?### .*$$' $(MAKEFILE_LIST) \
	| sort -u \
	| awk 'BEGIN {FS = ":.*?### "}; {printf "\033[35m%-30s\033[0m %s\n", $$1, $$2}'
