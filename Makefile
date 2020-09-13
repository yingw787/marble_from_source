#!/usr/bin/env make

export APP_VERSION ?= $(shell git rev-parse --short HEAD)
export GIT_REPO_ROOT ?= $(shell git rev-parse --show-toplevel)

export DOCKER_IMAGE_NAME ?= marble

export USERID ?= $(shell id -u $(whoami))
export GROUPID ?= $(shell id -g $(whoami))

version:
	@echo '{"Version": "$(APP_VERSION)"}'

check:
	@echo "Checking system dependencies..."
	# GNU Make 4.2.1
	# Built for x86_64-pc-linux-gnu
	# Copyright (C) 1988-2016 Free Software Foundation, Inc.
	# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
	# This is free software: you are free to change and redistribute it.
	# There is NO WARRANTY, to the extent permitted by law.
	@echo $$(make --version)
	# Docker version 19.03.8, build afacb8b7f0
	@echo $$(docker --version)
	# git version 2.27.0
	@echo $$(git --version)

docker-build:
	docker build \
		--file ./Dockerfile \
		--tag $(DOCKER_IMAGE_NAME):$(APP_VERSION) \
		.
