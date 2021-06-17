all:
	make build

TAG ?= py39
BUILD_DATE ?= $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
BUILD_ARGS ?= --no-cache --build-arg BUILD_DATE=$(BUILD_DATE)
IMAGE ?= horneds/muffin:$(TAG)
PASSWORD ?=

login:
	echo $(PASSWORD) | docker login -u horneds --password-stdin

build:
	docker build $(BUILD_ARGS) \
		-f images/$(TAG).dockerfile \
		-t $(IMAGE) $(CURDIR)
	docker tag $(IMAGE) horneds/muffin:latest

upload: build
	docker push $(IMAGE)

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
	docker run -it $(IMAGE) bash

run: build
	docker run -it -p 8000:80 $(IMAGE)

shell: build
	docker run -it $(IMAGE) muffin app shell

test t:
	make py37 py38 py39 BUILD_ARGS=""
	pip install -r requirements.txt
	pytest tests

docs:
	docker run --rm \
	    -v $(CURDIR):/data \
	    -e DOCKERHUB_USERNAME=horneds \
	    -e DOCKERHUB_REPO_NAME=muffin \
	    -e DOCKERHUB_PASSWORD=$(PASSWORD) \
	    sheogorath/readme-to-dockerhub
