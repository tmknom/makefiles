# YAML
#
# Requirements:
# - Include `variables.mk`
#
# Usage:
#
# ```makefile
# YAMLLINT_CONFIG ?= .yamllint.yml
# -include $(COMPONENTS_DIR)/yaml.mk
#
# .PHONY: lint
# lint: lint/yaml
#
# .PHONY: fmt
# fmt: fmt/yaml
# ```

# Override variables
YAMLLINT_CONFIG ?=

# Variables
YAMLLINT ?= ghcr.io/tmknom/dockerfiles/yamllint:latest
PRETTIER ?= ghcr.io/tmknom/dockerfiles/prettier:latest
YAML_FILES ?= $(shell find . -name '*.y*ml' | grep -v -e '.makefiles/' -e 'tmp/' -e '.git/')

# Targets
.PHONY: lint/yaml
lint/yaml: ### Lint YAML files
	$(SECURE_DOCKER_RUN) $(YAMLLINT) --strict --config-file $(YAMLLINT_CONFIG) . || true

.PHONY: fmt/yaml
fmt/yaml: ### Format YAML files
	$(SECURE_DOCKER_RUN) $(PRETTIER) --write --parser=yaml $(YAML_FILES)
