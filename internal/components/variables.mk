# Variables
#
# Usage:
#
# ```makefile
# -include $(COMPONENTS_DIR)/variables.mk
# ```

# Fundamentals
GIT := $(shell \command -v git 2>/dev/null)
ROOT_DIR := $(shell $(GIT) rev-parse --show-toplevel)
MAKEFILES_SELF ?= $(shell cut -d/ -f1 <<<$(lastword $(MAKEFILE_LIST)))
CONFIG_DIR ?= $(__MAKEFILES_CONFIG_DIR)
SCRIPTS_DIR ?= $(__MAKEFILES_SCRIPTS_DIR)

# Docker commands
DOCKER := $(shell \command -v docker 2>/dev/null)
DOCKER_RUN ?= $(DOCKER) run $(__DOCKER_OPTIONS)
SECURE_DOCKER_RUN ?= $(DOCKER_RUN) $(__DOCKER_SECURE_OPTIONS)

# Docker options: used only internal
__DOCKER_OPTIONS ?=
__DOCKER_OPTIONS += -it
__DOCKER_OPTIONS += --rm
__DOCKER_OPTIONS += -v $(ROOT_DIR):$(ROOT_DIR)
__DOCKER_OPTIONS += -w $(ROOT_DIR)
__DOCKER_SECURE_OPTIONS ?=
__DOCKER_SECURE_OPTIONS += --read-only
__DOCKER_SECURE_OPTIONS += --security-opt no-new-privileges
__DOCKER_SECURE_OPTIONS += --cap-drop all
__DOCKER_SECURE_OPTIONS += --network none

# Makefiles: used only internal
__MAKEFILES_INTERNAL ?= internal
__MAKEFILES_INTERNAL_DIR ?= $(MAKEFILES_SELF)/$(__MAKEFILES_INTERNAL)

__MAKEFILES_SCRIPTS ?= scripts
__MAKEFILES_SCRIPTS_DIR ?= $(__MAKEFILES_INTERNAL_DIR)/$(__MAKEFILES_SCRIPTS)

__MAKEFILES_IGNORE ?= .ignore
__MAKEFILES_IGNORE_DIR ?= $(MAKEFILES_SELF)/$(__MAKEFILES_IGNORE)

__MAKEFILES_CONFIG ?= configurations
__MAKEFILES_CONFIG_DIR ?= $(__MAKEFILES_IGNORE_DIR)/$(__MAKEFILES_CONFIG)
