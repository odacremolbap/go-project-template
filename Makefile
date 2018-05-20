PKG := github.com/odacremolbap/go-project-template
BINARY := project-template
REGISTRY := pmercado 

GCO_ENABLED := 0
ARCH := amd64
ARCHS := amd64 arm64
OUTPUT_DIR := _output
SOURCE_FILES:=$(shell find . -name '*.go' | grep -v -E '(./vendor)')
VERSION ?= $(shell git describe --tags --always --dirty)
GO_FLAGS:=
GO_LDFLAGS:=

# OUTPUT_BINARIES := $(addprefix $(OUTPUT_DIR)/bin/, $(ARCHS)) 
OUTPUT_BINARIES := $(OUTPUT_DIR)/$(ARCH)/bin/$(BINARY)


all: build

build-%:
	@$(MAKE) --no-print-directory ARCH=$* build

.PHONY: all-build
all-build: $(addprefix build-, $(ARCHS))


.PHONY: check
check:
	@gofmt -l -s $(SOURCE_FILES) | read; if [ !$$? -eq 0 ]; then gofmt -s -d $(SOURCE_FILES); exit 1; fi

.PHONY: build
build: $(OUTPUT_BINARIES)


$(OUTPUT_BINARIES): $(SOURCE_FILES)
	@mkdir -p $(dir OUTPUT_BINARIES)
	go build $(GO_FLAGS) -ldflags "$(GO_LDFLAGS)" -o $@ $(PKG)/cmd/
