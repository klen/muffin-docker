all:
	make build

TAG ?= py39
BUILD_DATE ?= $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
BUILD_ARGS ?= --no-cache --build-arg BUILD_DATE=$(BUILD_DATE)

build:
	docker build $(BUILD_ARGS) \
		-f images/$(TAG).dockerfile \
		-t muffin:$(TAG) $(CURDIR)

py37:
	make build TAG=py37

py38:
	make build TAG=py38

py39:
	make build TAG=py39

py37-node:
	make build TAG=py37-node

py38-node:
	make build TAG=py38-node

py39-node:
	make build TAG=py39-node

bash: build
	docker run -it muffin:$(TAG) bash

run: build
	docker run -it -p 8000:80 muffin:$(TAG)

shell: build
	docker run -it muffin:$(TAG) muffin app shell
