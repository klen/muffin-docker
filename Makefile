all:
	make build

PY_VERSION ?= 3.12
PASSWORD ?=

login:
	echo $(PASSWORD) | docker login -u horneds --password-stdin

BUILD_DATE ?= $(shell date -u +'%Y-%m-%d')
BUILD_CACHE ?= --no-cache
BUILD_ARGS ?= $(BUILD_CACHE) --build-arg BUILD_DATE=$(BUILD_DATE) --build-arg PY_VERSION=$(PY_VERSION) --build-arg TAG=$(TAG)
BUILD_IMAGE ?= muffin
IMAGE ?= horneds/${BUILD_IMAGE}:py$(PY_VERSION)
build:
	docker build $(BUILD_ARGS) \
		-f images/$(BUILD_IMAGE).dockerfile \
		-t $(IMAGE) $(CURDIR)

upload: build
	docker push $(IMAGE)

py310:
	make build PY_VERSION=3.10

py311:
	make build PY_VERSION=3.11

py312:
	make build PY_VERSION=3.12

py313:
	make build PY_VERSION=3.13

py310-node:
	make build PY_VERSION=3.10 BUILD_IMAGE=muffin-node

py311-node:
	make build PY_VERSION=3.11.3 BUILD_IMAGE=muffin-node

py312-node:
	make build PY_VERSION=3.12 BUILD_IMAGE=muffin-node

py313-node:
	make build PY_VERSION=3.13 BUILD_IMAGE=muffin-node

latest: py312
latest-node: py312-node

bash: build
	docker run -it $(IMAGE) bash

run: build
	docker run -it -p 8000:80 --env GWORKERS=2 $(IMAGE)

shell: build
	docker run -it $(IMAGE) muffin app shell

test t:
	make py312 BUILD_ARGS=""
	pip install -r requirements.txt
	pytest tests --tag py312

docs:
	docker run --rm \
	    -v $(CURDIR):/data \
	    -e DOCKERHUB_USERNAME=horneds \
	    -e DOCKERHUB_REPO_NAME=muffin \
	    -e DOCKERHUB_PASSWORD=$(PASSWORD) \
	    sheogorath/readme-to-dockerhub
	docker run --rm \
	    -v $(CURDIR):/data \
	    -e DOCKERHUB_USERNAME=horneds \
	    -e DOCKERHUB_REPO_NAME=muffin-node \
	    -e DOCKERHUB_PASSWORD=$(PASSWORD) \
	    sheogorath/readme-to-dockerhub
