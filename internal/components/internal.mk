# Internal
#
# Requirements:
# - Include `variables.mk`
#
# Usage:
#
# ```makefile
# -include $(COMPONENTS_DIR)/internal.mk
# .PHONY: internal/update
# internal/update: internal/update/self internal/update/config
# ```

# Variables
CONFIG_REPO ?= https://github.com/tmknom/configurations.git
FULL_MAKEFILES_DIR ?= $(ROOT_DIR)/$(MAKEFILES_SELF)
FULL_CONFIG_DIR ?= $(ROOT_DIR)/$(CONFIG_DIR)

# Targets
.PHONY: internal/update
internal/update: internal/update/self internal/update/config ### Update makefiles in itself

.PHONY: internal/update/self
internal/update/self:
	cd $(FULL_MAKEFILES_DIR) && $(GIT) stash && $(GIT) switch main && $(GIT) pull origin main

.PHONY: internal/update/config
internal/update/config: internal/config/init
	cd $(FULL_CONFIG_DIR) && $(GIT) stash && $(GIT) switch main && $(GIT) pull origin main

.PHONY: internal/config/init
internal/config/init: $(CONFIG_DIR)/README.md
$(CONFIG_DIR)/README.md:
	@$(GIT) clone $(CONFIG_REPO) $(FULL_CONFIG_DIR) >/dev/null 2>&1

.PHONY: internal/debug/test
internal/debug/test:
	grep --no-filename -E '^.PHONY' $(MAKEFILE_LIST) | cut -d: -f2 | sort -u | \
	xargs -I {} /bin/bash -c "printf '\033[32mmake %-30s\033[0m %s\n' {} && make {} -n"

.PHONY: internal/debug/data
internal/debug/data:
	make -p | grep -v -e '#' -e "^\s*$$"
