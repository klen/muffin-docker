from __future__ import annotations

import requests


def test_base(run, tag):
    with run(f"horneds/muffin:{tag}"):
        res = requests.get("http://127.0.0.1:8000", timeout=5)
        assert res.status_code == 200
        assert "Hello from Muffin" in res.text
