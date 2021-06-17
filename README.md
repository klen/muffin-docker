[![tests](https://github.com/klen/muffin-docker/actions/workflows/tests.yml/badge.svg)](https://github.com/klen/muffin-docker/actions/workflows/tests.yml)
[![build](https://github.com/klen/muffin-docker/actions/workflows/build.yml/badge.svg)](https://github.com/klen/muffin-docker/actions/workflows/build.yml)
[![dockerhub](https://img.shields.io/docker/v/horneds/muffin/latest)](https://hub.docker.com/r/horneds/muffin)


# muffin-docker

[**Docker**](https://www.docker.com/) image with [**Muffin**](https://klen.github.io/muffin/) managed by [**Gunicorn**](https://gunicorn.org/)

## Supported tags

* [py37](https://github.com/klen/muffin-docker/blob/master/images/py37.dockerfile), [py37-node](https://github.com/klen/muffin-docker/blob/master/images/py37-node.dockerfile)
* [py38](https://github.com/klen/muffin-docker/blob/master/images/py38.dockerfile), [py38-node](https://github.com/klen/muffin-docker/blob/master/images/py38-node.dockerfile)
* [py39, latest](https://github.com/klen/muffin-docker/blob/master/images/py39.dockerfile), [py39-node, latest-node](https://github.com/klen/muffin-docker/blob/master/images/py39-node.dockerfile)

## How to use

* You don't need to clone the GitHub repo. You can use this image as a base image for other images, using this in your `Dockerfile`:

```Dockerfile
FROM horneds/muffin:latest

COPY ./app /app
```

It will expect a file at `/app/app.py`.

Or otherwise a file at `/app/main.py`.

And will expect it to contain a variable `app` with your "ASGI" application.

Then you can build your image from the directory that has your `Dockerfile`, e.g:

```bash
docker build -t myimage ./
```

* Run a container based on your image:

```bash
docker run -d --name mycontainer -p 80:80 myimage
```

You should be able to check it in your Docker container's URL, for example: http://127.0.0.1/ (or equivalent, using your Docker host).

## Dependencies and packages

You will probably also want to add any dependencies for your app and pin them
to a specific version, probably including Uvicorn and Gunicorn.

This way you can make sure your app always works as expected.

You could install packages with `pip` commands in your `Dockerfile`, using a
`requirements.txt`, or even using [Poetry](https://python-poetry.org/).

### Using PIP

Here's a small example of one of the ways you could install your dependencies
making sure you have a pinned version for each package.

Let's say you have a your dependencies in a file `requirements.txt`.

Then you could have a `Dockerfile` like:

```Dockerfile
FROM horneds/muffin:latest

# Copy and install dependencies
COPY ./requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

COPY ./app /app
```

That will:

* Copy your application requirements.
* Install the dependencies.
* Then copy your app code.
