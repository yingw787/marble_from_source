#!/usr/bin/env make

export APP_VERSION ?= $(shell git rev-parse --short HEAD)
export GIT_REPO_ROOT ?= $(shell git rev-parse --show-toplevel)

export DOCKER_IMAGE_NAME ?= marble

export USERID ?= $(shell id -u $(whoami))
export GROUPID ?= $(shell id -g $(whoami))

export AWS_PROFILE=ying.wang
export AWS_OSM_PBF_BUCKETNAME=yingw787-kde-marble-osm-snapshots

export OSM_FILENAME=north-america-latest.osm.md5sum-25db67c763ad8b856c9ff3d0f18ce14c.gen-2020-09-12T20:42:02Z.pbf

export S3_ACCESS_KEY ?= $(shell aws configure get aws_access_key_id --profile $(AWS_PROFILE))
export S3_SECRET_KEY ?= $(shell aws configure get aws_secret_access_key --profile $(AWS_PROFILE))

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
	# aws-cli/1.18.131 Python/3.8.2 Linux/5.4.0-47-generic botocore/1.17.54
	@echo $$(aws --version)
	# s4cmd version 2.1.0
	@echo $$(s4cmd --version)

# Download data dump to local.
setup:
	S3_ACCESS_KEY=$(S3_ACCESS_KEY) S3_SECRET_KEY=$(S3_SECRET_KEY) s4cmd --num-threads=12 --debug --verbose get s3://$(AWS_OSM_PBF_BUCKETNAME)/$(OSM_FILENAME) $(OSM_FILENAME) --profile $(AWS_PROFILE)

# Synchronize data dump to S3.
update-s3:
	S3_ACCESS_KEY=$(S3_ACCESS_KEY) S3_SECRET_KEY=$(S3_SECRET_KEY) s4cmd --num-threads=12 --debug --verbose put $(OSM_FILENAME) s3://$(AWS_OSM_PBF_BUCKETNAME)/$(OSM_FILENAME)

docker-build:
	docker build \
		--file ./Dockerfile \
		--tag $(DOCKER_IMAGE_NAME):$(APP_VERSION) \
		.

# From: https://stackoverflow.com/a/14061796
# If the first argument is "run"...
ifeq (docker-run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

export XSOCK=/tmp/.X11-unix

# Lifts command into `docker run` context.
docker-run: docker-build
	docker run \
		--rm \
		-it \
		-v $(shell pwd):/app \
		-v $(HOME)/.Xauthority:/root/.Xauthority \
		-v $(XSOCK):$(XSOCK) \
		-e DISPLAY=unix$(DISPLAY) \
		--net=host \
		$(DOCKER_IMAGE_NAME):$(APP_VERSION) \
		bash -c "$(RUN_ARGS)"

docker-bash:
	$(MAKE) docker-run bash
