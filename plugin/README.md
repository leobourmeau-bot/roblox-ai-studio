# Roblox Studio plugin

The plugin is a Rojo model whose `.plugin.luau` entry point runs with Roblox Studio's Plugin
`RunContext`. It creates a
toolbar, a **Roblox AI** button, and a persistent DockWidget. The controller owns all Roblox event
connections and destroys them when Studio unloads the plugin.

The DockWidget shows `http://127.0.0.1:8765` and exposes a **Refresh** button. Refresh performs
`GET http://127.0.0.1:8765/health` with `HttpService:GetAsync` inside `pcall`; it reports success or
failure without implementing assistant or AI behavior. Roblox Studio may request permission for
the local HTTP endpoint on first use.

Every Luau source file uses strict mode. UI construction is isolated from lifecycle management so
future transport and assistant features can be added behind explicit interfaces.

Wally is the package manager for this workspace. The bootstrap deliberately has no third-party
runtime dependency; run `wally install` before every build so dependency installation remains part
of the standard workflow when packages are introduced.
