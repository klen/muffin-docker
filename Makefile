all:
	make build

PY_VERSION ?= 3.11.3
PASSWORD ?=

login:
	echo $(PASSWORD) | docker login -u horneds --password-stdin

BUILD_DATE ?= $(shell date -u +'%Y-%m-%d')
BUILD_CACHE ?= --no-cache
BUILD_ARGS ?= $(BUILD_CACHE) --build-arg BUILD_DATE=$(BUILD_DATE) --build-arg PY_VERSION=$(PY_VERSION) --build-arg TAG=$(TAG)
BUILD_IMAGE ?= muffin
TAG ?= py311
IMAGE ?= horneds/${BUILD_IMAGE}:$(TAG)
build:
	docker build $(BUILD_ARGS) \
		-f images/$(BUILD_IMAGE).dockerfile \
		-t $(IMAGE) $(CURDIR)

build-node:
	make build BUILD_IMAGE=muffin-node TAG=py311

upload: build
	docker push $(IMAGE)

py38:
	make build TAG=py38 PY_VERSION=3.8

py39:
	make build TAG=py39 PY_VERSION=3.9

py310:
	make build TAG=py310 PY_VERSION=3.10

py311:
	make build TAG=py311 PY_VERSION=3.11.3
	docker tag horneds/muffin:py311 horneds/muffin:latest

py38-node:
	make build TAG=py38 BUILD_IMAGE=muffin-node

py39-node:
	make build TAG=py39 BUILD_IMAGE=muffin-node

py310-node:
	make build TAG=py310 BUILD_IMAGE=muffin-node

py311-node:
	make build TAG=py311 BUILD_IMAGE=muffin-node
	docker tag horneds/muffin:py311-node horneds/muffin:latest-node

latest: py311
latest-node: py311-node

bash: build
	docker run -it $(IMAGE) bash

run: build
	docker run -it -p 8000:80 --env GWORKERS=2 $(IMAGE)

shell: build
	docker run -it $(IMAGE) muffin app shell

test t:
	make py38 py39 py310 BUILD_ARGS=""
	pip install -r requirements.txt
	pytest tests

docs:
	docker run --rm \
	    -v $(CURDIR):/data \
	    -e DOCKERHUB_USERNAME=horneds \
	    -e DOCKERHUB_REPO_NAME=muffin \
	    -e DOCKERHUB_PASSWORD=$(PASSWORD) \
	    sheogorath/readme-to-dockerhub
