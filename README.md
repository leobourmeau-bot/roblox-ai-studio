# Roblox AI

Roblox AI is an open-source foundation for a professional Roblox Studio assistant. This bootstrap
contains a real Studio plugin shell and a production-oriented HTTP service; it intentionally does
not implement AI behavior.

## What works today

- A Rojo-built Studio plugin with a **Roblox AI** toolbar button and DockWidget.
- A DockWidget interface that displays the product title and backend connection state.
- A typed FastAPI service with `GET /health` returning `{"status":"ok"}`.
- Reproducible Roblox tooling through Rokit, dependency management through Wally, Python quality
  gates through Ruff, mypy, and Pytest, and container builds through Docker.
- Continuous integration for both the Luau and Python workspaces.

## Repository layout

| Path | Responsibility |
| --- | --- |
| `backend/` | FastAPI application package and container image |
| `plugin/` | Roblox Studio plugin entry point, controller, and UI |
| `shared/` | Versioned Luau contracts and constants shared across plugin modules |
| `docs/` | Architecture and development documentation |
| `tests/` | Tests organized by runtime boundary |
| `.github/` | Continuous integration and dependency automation |

## Quick start

### Backend

Python 3.12 is required.

```shell
cd backend
python -m venv .venv
python -m pip install -e ".[dev]"
python -m uvicorn roblox_ai_backend.application:create_app --factory --reload --port 8765
```

Open `http://127.0.0.1:8765/health` to verify the service.

### Studio plugin

Install [Rokit](https://github.com/rojo-rbx/rokit) and the Roblox Studio Rojo plugin, then run:

```shell
rokit install
wally install
New-Item -ItemType Directory -Force -Path .\dist | Out-Null
rojo build .\default.project.json --output .\dist\RobloxAIStudio.rbxm
$pluginsDirectory = Join-Path $env:LOCALAPPDATA "Roblox\Plugins"
New-Item -ItemType Directory -Force -Path $pluginsDirectory | Out-Null
Copy-Item -Force .\dist\RobloxAIStudio.rbxm $pluginsDirectory
```

Restart Roblox Studio after copying the file. The
**Roblox AI** button appears in the Plugins toolbar and toggles the DockWidget.

For the complete workflow and verification commands, see [Development](docs/development.md).
For component boundaries and design constraints, see [Architecture](docs/architecture.md).

## Project status

This repository is at the architecture-bootstrap stage. Network transport, authentication,
assistant behavior, and model integrations are deliberately outside the current scope.

## License

Roblox AI is available under the [MIT License](LICENSE).
