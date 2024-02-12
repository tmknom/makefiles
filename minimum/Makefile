# If this variable is not set, the program /bin/sh is used as the shell.
SHELL := /bin/bash

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

# Include initial components
COMPONENTS_DIR ?= $(shell cut -d/ -f1 <<<$(lastword $(MAKEFILE_LIST)))/internal/components
include $(COMPONENTS_DIR)/flags.mk
include $(COMPONENTS_DIR)/variables.mk

# Targets: Help
-include $(COMPONENTS_DIR)/help.mk
.PHONY: help
help: help/primary ## Display help (details: make help/all)

# Targets: Build
-include $(COMPONENTS_DIR)/workflow.mk
-include $(COMPONENTS_DIR)/yaml.mk
-include $(COMPONENTS_DIR)/shell.mk

# Targets: Release
-include $(COMPONENTS_DIR)/release.mk

# Targets: Internal
-include $(COMPONENTS_DIR)/internal.mk
