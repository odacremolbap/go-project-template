REPO := github.com/odacremolbap/go-project-template
BINARY := project-template
REGISTRY := pmercado 

GCO_ENABLED := 0
ARCH := amd64
ARCHS := amd64 arm64
OUTPUT_DIR := _output
SOURCE_FILES:=$(shell find . -name '*.go' | grep -v -E '(./vendor)')
VERSION ?= $(shell git describe --tags --always --dirty)
DATE:=$(shell TZ=UTC date +'%y.%m.%d %H:%M:%S')
GO_FLAGS:=
GO_LDFLAGS:=-X $(REPO)/pkg/version.Version=${VERSION} -X \"$(REPO)/pkg/version.Date=${DATE}\"

# OUTPUT_BINARIES := $(addprefix $(OUTPUT_DIR)/bin/, $(ARCHS)) 
OUTPUT_BINARIES := $(OUTPUT_DIR)/$(ARCH)/bin/$(BINARY)


all: build
.PHONY: release
release: \
	clean \
	check \
	test \
	all-build
	
build-%:
	@$(MAKE) --no-print-directory ARCH=$* build

.PHONY: all-build
all-build: $(addprefix build-, $(ARCHS))


.PHONY: check
check:
	@gofmt -l -s $(SOURCE_FILES) | read; if [ !$$? -eq 0 ]; then gofmt -s -d $(SOURCE_FILES); exit 1; fi
	@go vet $(shell go list ./... | grep -v '/vendor/')

.PHONY: build
build: $(OUTPUT_BINARIES)


$(OUTPUT_BINARIES): $(SOURCE_FILES)
	@mkdir -p $(dir OUTPUT_BINARIES)
	go build $(GO_FLAGS) -ldflags "$(GO_LDFLAGS)" -o $@ $(REPO)/cmd/

.PHONY: clean
clean:
	rm -rf _output/

.PHONY: test
test:
	go test -v $(shell go list ./... | grep -v '/vendor/')

