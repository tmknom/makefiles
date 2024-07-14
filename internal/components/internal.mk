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
FULL_STATE_DIR ?= $(ROOT_DIR)/$(STATE_DIR)

# Targets
.PHONY: internal/update
internal/update: internal/self/update internal/config/update ### Update makefiles in itself

.PHONY: internal/init
internal/init: internal/self/init internal/config/init ### Init makefiles and configurations

# Targets: Internal/Self
.PHONY: internal/self/update
internal/self/update:
	cd $(FULL_MAKEFILES_DIR) && $(GIT) stash && $(GIT) switch main && $(GIT) pull origin main
	make internal/self/state

.PHONY: internal/self/init
internal/self/init: $(STATE_DIR)/initialized
$(STATE_DIR)/initialized:
	@mkdir -p $(STATE_DIR)
	@echo "Initialized at $(shell date -Iseconds)" > $(STATE_DIR)/initialized
	@make internal/self/state

.PHONY: internal/self/state
internal/self/state: $(STATE_DIR)/initialized
	@cd $(FULL_MAKEFILES_DIR) && $(GIT) log -1 --format=%H >$(FULL_STATE_DIR)/makefiles

# Targets: Internal/Config
.PHONY: internal/config/update
internal/config/update:
	cd $(FULL_CONFIG_DIR) && $(GIT) stash && $(GIT) switch main && $(GIT) pull origin main
	make internal/config/state

.PHONY: internal/config/init
internal/config/init: $(STATE_DIR)/configurations
$(STATE_DIR)/configurations:
	@$(GIT) clone $(CONFIG_REPO) $(FULL_CONFIG_DIR) >/dev/null 2>&1
	@make internal/config/state

.PHONY: internal/config/state
internal/config/state: $(STATE_DIR)/initialized
	@cd $(FULL_CONFIG_DIR) && $(GIT) log -1 --format=%H >$(FULL_STATE_DIR)/configurations

# Targets: Internal/Repo
__REPO_ORIGIN ?= $(shell git config --get remote.origin.url)
__REPO_OWNER ?= $(shell gh config get -h github.com user)
__REPO_NAME ?= $(shell basename -s .git $(__REPO_ORIGIN))

.PHONY: internal/repo/init
internal/repo/init: $(STATE_DIR)/repository
$(STATE_DIR)/repository:
	@read -p "Confirm repository init? (y/N): " answer && \
	case "$${answer}" in \
	  [yY]*) $(SCRIPTS_DIR)/repo/main.sh "$(__REPO_OWNER)/$(__REPO_NAME)" ;; \
	  *) echo "Cancel repository init." ;; \
	esac
	echo "Configured at $(shell date -Iseconds)" > $(STATE_DIR)/repository

# Targets: Internal/Debug
.PHONY: internal/debug/test
internal/debug/test:
	grep --no-filename -E '^.PHONY' $(MAKEFILE_LIST) | cut -d: -f2 | sort -u | \
	xargs -I {} /bin/bash -c "printf '\033[32mmake %-30s\033[0m %s\n' {} && make {} -n"

.PHONY: internal/debug/data
internal/debug/data:
	make -p | grep -v -e '#' -e "^\s*$$"
