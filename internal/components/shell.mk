# Shell
#
# Requirements:
# - Include `variables.mk`
#
# Usage:
#
# ```makefile
# -include $(COMPONENTS_DIR)/shell.mk
#
# .PHONY: lint
# lint: lint/shell
#
# .PHONY: fmt
# fmt: fmt/shell
# ```

# Variables
SHELLCHECK ?= koalaman/shellcheck:stable
SHFMT ?= mvdan/shfmt
SHELL_FILES ?= $(shell find . -name '*.sh' | grep -v -e '.makefiles/' -e 'tmp/' -e '.git/')

# Targets
.PHONY: lint/shell
lint/shell: ### Lint shell files
	@if [[ ! "$(SHELL_FILES)" ]]; then printf "Skip: $@\n"; exit 0; fi; \
	printf "Run: \033[33m%-30s\033[0m %s\n" "$@"; \
	$(SECURE_DOCKER_RUN) $(SHELLCHECK) $(SHELL_FILES) || true

.PHONY: fmt/shell
fmt/shell: ### Format shell files
	@if [[ ! "$(SHELL_FILES)" ]]; then printf "Skip: $@\n"; exit 0; fi; \
	printf "Run: \033[33m%-30s\033[0m %s\n" "$@"; \
	$(SECURE_DOCKER_RUN) $(SHFMT) -i 2 -ci -bn -w $(SHELL_FILES)
