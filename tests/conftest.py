from __future__ import annotations

import time
from contextlib import contextmanager
from typing import cast

import docker
import pytest
from docker.errors import NotFound
from docker.models.containers import Container

client = docker.from_env()


def pytest_addoption(parser):
    parser.addoption("--tag", default="py312", help="Python version")


def pytest_generate_tests(metafunc):
    if "tag" in metafunc.fixturenames:
        tag = metafunc.config.getoption("tag")
        metafunc.parametrize("tag", [tag])


@pytest.fixture()
def run():
    @contextmanager
    def run_container(
        image, name="muffin-docker-test", ports=None, *, detach=True, sleep=1, **kwargs
    ):
        try:
            previous = cast(Container, client.containers.get(name))
            previous.stop()
            previous.remove()
        except NotFound:
            pass

        container = cast(
            Container,
            client.containers.run(
                image, name=name, ports=ports or {"80": "8000"}, detach=detach, **kwargs
            ),
        )
        time.sleep(sleep)
        yield container

        container.stop()
        container.remove()

    return run_container
