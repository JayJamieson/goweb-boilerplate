include .env

.PHONY: all
all: help

# Go related variables.
GOBASE=$(shell pwd)
GOPATH=$(GOBASE)/vendor:$(GOBASE)
GOBIN=$(GOBASE)/bin
GOFILES=$(wildcard *.go)
ADDR=8080
# PROJECTNAME=$(shell basename "$(pwd)")
PROJECTNAME=$(shell basename $(GOBASE))

# save errors to file for easier reading
STDERR=/tmp/.$(PROJECTNAME)-stderr.txt

# store PID of main.go to keep track of running process
PID=/tmp/.$(PROJECTNAME).pid

# silence some of the verbose output
MAKEFLAGS += --silent

# install dependencies, runs go get
.PHONY: install
install: go-get

## run: Run in development mode. Ctrl + C to stop
.PHONY: run
run: compile
	@echo "  >  Running binary $(PROJECTNAME)..."
	@-. $(GOBASE)/.env && $(GOBIN)/$(PROJECTNAME)

## compile: Compile the binary.
.PHONY: compile
compile:
	@-touch $(STDERR)
	@-rm $(STDERR)
	@-$(MAKE) -s go-compile 2> $(STDERR)
	@cat $(STDERR) | sed -e '1s/.*/\nError:\n/' | sed 's/make\[.*/ /' | sed "/^/s/^/     /" 1>&2

## exec: Run given command, wrapped with custom GOPATH. e.g; make exec run="go test ./..."
.PHONY: exec
exec:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) $(run)

## clean: Clean build files. Runs `go clean` internally.
.PHONY: clean
clean:
	$(MAKE) go-clean

.PHONY: go-compile
go-compile: go-clean go-get go-build

.PHONY: go-build
go-build:
	@echo "  >  Building binary..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go build -o $(GOBIN)/$(PROJECTNAME) $(GOFILES)

.PHONY: go-generate
go-generate:
	@echo "  >  Generating dependency files..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go generate $(generate)

.PHONY: go-get
go-get:
	@echo "  >  Checking if there is any missing dependencies..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go get $(get)

.PHONY: go-install
go-install:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go install $(GOFILES)

.PHONY: go-clean
go-clean:
	@echo "  >  Cleaning build cache"
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go clean

.PHONY: help
help: Makefile
	@echo
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## up: run docker-compose build and docker-compose up -d
# docker-compose up -d redis postgresql
.PHONY: up
up:
	docker-compose build
	docker-compose up -d

## down: run docker-compose down
.PHONY: down
down:
	docker-compose down

.PHONY: test
test:
	go test ./...

.PHONY: vet
vet:
	go vet ./...

.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: image
image:
	docker build -t goweb-boilerplate .

watch:
	while true; do \
		make $(WATCHMAKE); \
		inotifywait -qre close_write .; \
	done