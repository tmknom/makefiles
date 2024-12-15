# Go
#
# Requirements:
# - Include `variables.mk`
#
# Usage:
#
# ```makefile
# -include $(COMPONENTS_DIR)/go.mk
# .PHONY: build
# build: build/go
# ```

# Variables
VERSION = $(shell \git tag --sort=-v:refname | head -1)
COMMIT = $(shell \git rev-parse HEAD)
DATE = $(shell \date +"%Y-%m-%d")
URL = https://github.com/$(REPO_OWNER)/$(REPO_NAME)/releases/tag/$(VERSION)
LDFLAGS ?= "-X main.name=$(REPO_NAME) -X main.version=$(VERSION) -X main.commit=$(COMMIT) -X main.date=$(DATE) -X main.url=$(URL)"

# Targets
.PHONY: deps/go
deps/go: ### Install Go modules
	go mod tidy
	go mod verify
	go mod download

.PHONY: build/go
build/go: deps/go ### Build executable binary
	go build -ldflags=$(LDFLAGS) -o bin/$(REPO_NAME) ./cmd/$(REPO_NAME)

.PHONY: test/go
test/go: build/go ### Test Go
	go test ./...

.PHONY: lint/go
lint/go: ### Lint Go
	go vet ./...
	goimports -w .

.PHONY: prepare/go
prepare/go: ### Prepare Go projects
	go install golang.org/x/tools/cmd/goimports@latest
