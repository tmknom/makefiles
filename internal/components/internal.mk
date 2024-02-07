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

# Variables
CONFIG_REPO ?= https://github.com/tmknom/configurations.git
FULL_MAKEFILES_DIR ?= $(ROOT_DIR)/$(MAKEFILES_SELF)
FULL_CONFIG_DIR ?= $(ROOT_DIR)/$(CONFIG_DIR)

# Targets
.PHONY: internal/update
internal/update: internal/self/update internal/config/update ### Update makefiles in itself

# Targets: Internal/Self
.PHONY: internal/self/update
internal/self/update:
	cd $(FULL_MAKEFILES_DIR) && $(GIT) stash && $(GIT) switch main && $(GIT) pull origin main

# Targets: Internal/Config
.PHONY: internal/config/update
internal/config/update: internal/config/init
	cd $(FULL_CONFIG_DIR) && $(GIT) stash && $(GIT) switch main && $(GIT) pull origin main

.PHONY: internal/config/init
internal/config/init: $(CONFIG_DIR)/README.md
$(CONFIG_DIR)/README.md:
	@$(GIT) clone $(CONFIG_REPO) $(FULL_CONFIG_DIR) >/dev/null 2>&1

# Targets: Internal/Repo
__REPO_ORIGIN ?= $(shell git config --get remote.origin.url)
__REPO_OWNER ?= $(shell gh config get -h github.com user)
__REPO_NAME ?= $(shell basename -s .git $(__REPO_ORIGIN))

.PHONY: internal/repo/init
internal/repo/init:
	$(SCRIPTS_DIR)/repo/main.sh "$(__REPO_OWNER)/$(__REPO_NAME)"

# Targets: Internal/Debug
.PHONY: internal/debug/test
internal/debug/test:
	grep --no-filename -E '^.PHONY' $(MAKEFILE_LIST) | cut -d: -f2 | sort -u | \
	xargs -I {} /bin/bash -c "printf '\033[32mmake %-30s\033[0m %s\n' {} && make {} -n"

.PHONY: internal/debug/data
internal/debug/data:
	make -p | grep -v -e '#' -e "^\s*$$"
