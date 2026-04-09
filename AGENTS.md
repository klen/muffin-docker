# AGENTS.md

## What this repo is

- Builds and publishes Docker images (`horneds/muffin`, `horneds/muffin-node`),
  not a full app codebase.
- Core logic lives in `images/muffin.dockerfile`, `images/muffin-node.dockerfile`, and `start.sh`.

## Commands you should not guess

- Build default image (Python 3.14): `make py314`.
- Build node variant: `make py314-node` (or `make build BUILD_IMAGE=muffin-node PY_VERSION=3.14`).
- Run local container smoke test manually: `make run` (maps container `80` to host `8000`).
- Repo test flow (same order as CI intent):
  `pip install -r requirements.txt` -> `make <tag>` -> `pytest tests --tag <tag>`.
- Fast local default test: `make test` (builds `py314`, installs test deps, runs pytest).

## Testing quirks

- Tests require a working Docker daemon and host port `8000` available.
- `pytest` adds a custom `--tag` option in `tests/conftest.py` (default is `py312` if omitted).
- `tests/test_base.py` rewrites tags like `py314` -> `py3.14` before selecting image tags.

## Build/publish workflow facts

- CI test matrix builds tags `py310`..
  `py314` and runs `pytest tests --tag <tag>` (`.github/workflows/tests.yml`).
- Publish workflows (`build.yml`,
  `docs.yml`) run only after `tests` succeeds on `master` (`workflow_run`).
- `make upload` requires Docker Hub auth via `make login PASSWORD=...`.

## Runtime/entrypoint behavior

- Container startup is driven by `start.sh` and Gunicorn (not `uvicorn` directly).
- App module auto-detection order is fixed:
  `/app/app.py` -> `/app/main.py` -> `/app/app/app.py` -> `/app/app/main.py`.
- Override via env vars when needed: `MODULE_NAME`, `VARIABLE_NAME`, or full `APP_MODULE`;
  server binds via `GBIND` or `HOST`/`PORT`.

## Image-specific gotcha

- `muffin-node` builds `FROM horneds/muffin:py$PY_VERSION`;
  local node image builds may pull a remote base if that tag is not present locally.
