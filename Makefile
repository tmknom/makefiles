-include minimum/Makefile

# Variables: fundamentals
RELEASE_WORKFLOW ?= release.yml
SHELL_FILES ?= $(shell find . -name '*.sh' | grep -v -e .git/ -e .makefiles/ -e tmp/)

# Variables: commands
GH ?= $(shell \command -v gh 2>/dev/null)

# Variables: container images
SHELLCHECK ?= $(SECURE_DOCKER_RUN) koalaman/shellcheck:stable
SHFMT ?= $(SECURE_DOCKER_RUN) mvdan/shfmt

# Targets: Build code
.PHONY: build
build: fmt lint ## Run format and lint

# Targets: Lint code
.PHONY: lint
lint: lint/workflow lint/yaml lint/shell ## Lint workflow files and YAML files

.PHONY: lint/shell
lint/shell:
	$(SHELLCHECK) $(SHELL_FILES) || true

# Targets: Format code
.PHONY: fmt
fmt: fmt/yaml fmt/shell ## Format YAML files

.PHONY: fmt/shell
fmt/shell:
	$(SHFMT) -i 2 -ci -bn -w $(SHELL_FILES)

# Targets: Release
.PHONY: release
release: ## Start release process
	@read -p "Bump up to (patch / minor / major): " answer && \
	case "$${answer}" in \
		'patch') make release/patch ;; \
		'minor') make release/minor ;; \
		'major') make release/major ;; \
		*) echo "Error: invalid parameter: $${answer}"; exit 1 ;; \
	esac && \
	make release/show

.PHONY: release/patch
release/patch:
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=patch

.PHONY: release/minor
release/minor:
	$(GH) workflow run $(RELEASE_WORKFLOW) -f level=minor

.PHONY: release/major
release/major:
	@read -p "Confirm major version upgrade? (y/N):" answer && \
	case "$${answer}" in \
	  [yY]*) $(GH) workflow run $(RELEASE_WORKFLOW) -f level=major ;; \
	  *) echo "Cancel major version upgrade." ;; \
	esac

.PHONY: release/show
release/show:
	@echo 'Starting release...'
	@sleep 5
	@id=$$($(GH) run list --limit 1 --json databaseId --jq '.[0].databaseId' --workflow $(RELEASE_WORKFLOW)) && \
	$(GH) run watch $${id}
	@sleep 1
	$(GH) release view --web
