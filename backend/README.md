# Backend service

The backend is an installable Python 3.12 package. Its ASGI entry point is an application factory,
so tests and server processes receive isolated FastAPI instances instead of sharing mutable module
state.

## Run locally

```shell
python -m pip install -e ".[dev]"
python -m uvicorn roblox_ai_backend.application:create_app --factory --reload --port 8765
```

## API

`GET /health` is the only public endpoint in the bootstrap release. A successful response has HTTP
status `200` and the exact JSON body `{"status":"ok"}`.

## Quality checks

Run these commands from this directory:

```shell
python -m ruff check src ../tests
python -m ruff format --check src ../tests
python -m mypy src ../tests/backend
python -m pytest
```
