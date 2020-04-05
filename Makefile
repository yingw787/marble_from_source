.PHONY: build

export APP_VERSION ?= $(shell git rev-parse --short HEAD)

build:
	docker build $$(pwd)/conf
