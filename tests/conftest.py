import time
from contextlib import contextmanager

import docker
import pytest


client = docker.from_env()


def pytest_addoption(parser):
    parser.addoption("--tag", default="py39", help="Python version")


def pytest_generate_tests(metafunc):
    if "tag" in metafunc.fixturenames:
        tag = metafunc.config.getoption("tag")
        metafunc.parametrize("tag", [tag])


@pytest.fixture
def run():

    @contextmanager
    def run_container(
            image, name='muffin-docker-test', ports={'80': '8000'},
            detach=True, sleep=1, **kwargs):
        try:
            previous = client.containers.get(name)
            previous.stop()
            previous.remove()
        except docker.errors.NotFound:
            pass

        container = client.containers.run(image, name=name, ports=ports, detach=detach, **kwargs)
        time.sleep(sleep)
        yield container

        container.stop()
        container.remove()

    return run_container


# pylama:ignore=D
