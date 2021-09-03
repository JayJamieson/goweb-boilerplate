include .env

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

foo:
	echo "$(PROJECTNAME)"

# install dependencies, runs go get
install: go-get

## start: Start in development mode. Ctrl + C to stop
run: compile
	@echo "  >  Running binary $(PROJECTNAME)..."
	@-$(GOBIN)/$(PROJECTNAME)

## compile: Compile the binary.
compile:
	@-touch $(STDERR)
	@-rm $(STDERR)
	@-$(MAKE) -s go-compile 2> $(STDERR)
	@cat $(STDERR) | sed -e '1s/.*/\nError:\n/' | sed 's/make\[.*/ /' | sed "/^/s/^/     /" 1>&2

## exec: Run given command, wrapped with custom GOPATH. e.g; make exec run="go test ./..."
exec:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) $(run)

## clean: Clean build files. Runs `go clean` internally.
clean:
	$(MAKE) go-clean

go-compile: go-clean go-get go-build

go-build:
	@echo "  >  Building binary..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go build -o $(GOBIN)/$(PROJECTNAME) $(GOFILES)

go-generate:
	@echo "  >  Generating dependency files..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go generate $(generate)

go-get:
	@echo "  >  Checking if there is any missing dependencies..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go get $(get)

go-install:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go install $(GOFILES)

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
up:
	docker-compose build
	docker-compose up -d

## down: run docker-compose down
down:
	docker-compose down

test:
	go test ./...

vet:
	go vet ./...

fmt:
	go fmt ./...

image:
	docker build -t goweb-boilerplate .