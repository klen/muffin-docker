import requests


def test_base(run, pyversion):
    with run(f"muffin:{pyversion}"):
        res = requests.get('http://127.0.0.1:8000')
        assert res.status_code == 200
        assert 'Hello from Muffin' in res.text


# pylama:ignore=D
