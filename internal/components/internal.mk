# Internal
#
# Requirements:
# - Include `variables.mk`
#
# Usage:
#
# ```makefile
# -include $(COMPONENTS_DIR)/internal.mk
# ```

# Targets
.PHONY: internal/update
internal/update: ### Update makefiles in itself
	cd $(MAKEFILES_SELF) && $(GIT) stash && $(GIT) switch main && $(GIT) pull origin main
	cd $(CONFIG_DIR) && $(GIT) stash && $(GIT) switch main && $(GIT) pull origin main

# Targets: Internal/Debug
.PHONY: internal/debug/test
internal/debug/test:
	grep --no-filename -E '^.PHONY' $(MAKEFILE_LIST) | cut -d: -f2 | sort -u | \
	xargs -I {} /bin/bash -c "printf '\033[32mmake %-30s\033[0m %s\n' {} && make {} -n"

.PHONY: internal/debug/data
internal/debug/data:
	make -p | grep -v -e '#' -e "^\s*$$"
