# Architecture

## Design goals

Roblox AI is split at the Roblox security boundary. The Studio plugin owns editor interaction and
presentation. The backend owns server-side capabilities. The bootstrap does not connect those
components yet, which keeps the transport and security model open for an explicit design review.

The architecture favors small construction functions, immutable configuration, dependency
direction toward stable contracts, and lifecycle ownership. Neither runtime relies on mutable
process-wide application state.

## Component boundaries

```text
Roblox Studio                         Python process
┌──────────────────────────────┐      ┌──────────────────────────────┐
│ PluginController             │      │ create_app                   │
│  ├─ toolbar + button         │      │  └─ API router factory      │
│  ├─ DockWidget lifecycle     │      │      └─ /health             │
│  ├─ local health probe ──────┼─────>└──────────────────────────────┘
│  └─ WidgetView               │
│                              │
│ Shared                       │
│  └─ immutable configuration  │
└──────────────────────────────┘
```

### Plugin

`plugin/src/RobloxAI.plugin.luau` is the only executable entry point. Rojo compiles it with the
Plugin `RunContext`, where it constructs a
`PluginController`, which owns toolbar, DockWidget, and event lifetimes. `WidgetView` only creates
and updates interface instances. The controller also owns the single local health request, calls
`HttpService:GetAsync` inside `pcall`, and translates its outcome into view state. It disconnects
all events and destroys all owned instances when Roblox Studio unloads the plugin.

`shared/src` contains strict Luau contracts that Rojo maps next to the plugin entry point. Wally is
the package boundary for future third-party Luau dependencies. No package is added until a concrete
runtime need justifies it.

### Backend

`roblox_ai_backend.application.create_app` constructs a fresh FastAPI application. Router factories
follow the same rule, which prevents imports from creating shared mutable routers or ASGI apps.
Pydantic schemas define response contracts at the HTTP boundary. Immutable `AppSettings` provides
instance metadata without environment reads or hidden state.

### Tests

Tests live outside deployable packages under `tests/`, grouped by runtime. Backend contract tests
exercise the application through an ASGI test client. The plugin pipeline checks formatting and
uses Rojo to compile the complete installable model.

## Dependency rules

- Plugin UI modules must not perform network or persistence operations.
- Plugin lifecycle code may depend on UI and shared contracts; shared code may not depend on the
  plugin.
- Backend route modules depend on schemas, not on Roblox-specific UI concepts.
- New external integrations require an interface at the owning runtime boundary and tests that do
  not call the live service.
- Secrets and user data must never cross a boundary without a documented threat model.

## Future decisions

Transport beyond the local health probe, authentication, authorization, request correlation,
persistence, observability, model providers, and prompt execution are intentionally undecided.
Each is a production design decision, not an extension of the health endpoint or connection-status
view.
