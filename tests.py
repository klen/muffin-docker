import os
import docker


client = docker.from_env()


def test_base():
    image = 'muffin:py39'
