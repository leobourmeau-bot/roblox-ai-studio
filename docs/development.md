# Development

## Prerequisites

- Git
- Python 3.12
- Docker with Compose support
- Roblox Studio with the Rojo Studio plugin
- Rokit 1.x

Rokit reads `rokit.toml` and installs the repository's pinned Rojo, Wally, and StyLua versions:

```shell
rokit install
```

## Backend workflow

Create an isolated environment from `backend/`:

```shell
python -m venv .venv
python -m pip install -e ".[dev]"
```

Run the quality gates:

```shell
python -m ruff check src ../tests
python -m ruff format --check src ../tests
python -m mypy src ../tests/backend
python -m pytest
```

Start the service with reload support:

```shell
python -m uvicorn roblox_ai_backend.application:create_app --factory --reload --port 8765
```

The factory form is required. Do not add a module-level FastAPI application.

## Container workflow

From the repository root:

```shell
docker compose build
docker compose up
```

The image runs as UID 10001, exposes port 8765, and includes a `/health` container health check.
Compose also uses a read-only root filesystem and prevents privilege escalation.

## Plugin workflow

From PowerShell at the repository root on Windows:

```powershell
rokit install
wally install
stylua --check plugin shared
New-Item -ItemType Directory -Force -Path .\dist | Out-Null
rojo build .\default.project.json --output .\dist\RobloxAIStudio.rbxm
```

Install that exact build for the current Windows user:

```powershell
$pluginsDirectory = Join-Path $env:LOCALAPPDATA "Roblox\Plugins"
New-Item -ItemType Directory -Force -Path $pluginsDirectory | Out-Null
Copy-Item -Force .\dist\RobloxAIStudio.rbxm $pluginsDirectory
```

Then fully restart Roblox Studio. You can verify the target directory from Studio with
**Plugins > Plugins Folder**. For live development, start
`rojo serve .\default.project.json` and connect through the Rojo Studio plugin.

Every Luau file must begin with `--!strict`. The `.plugin.luau` suffix is required on the executable
entry point so Rojo emits a `Script` with the Plugin `RunContext`, rather than a `ModuleScript`. The
plugin entry point should remain composition-only;
put lifecycle behavior in controllers, presentation in UI modules, and cross-module values in
`shared/`.

## Continuous integration

GitHub Actions runs Python linting, formatting, strict type checks, and tests; formats and compiles
the plugin; and builds the production Dockerfile. Dependabot checks Python, Docker, and GitHub
Actions dependencies weekly.
