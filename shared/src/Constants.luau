--!strict

export type PluginConfiguration = {
    toolbarName: string,
    buttonId: string,
    buttonText: string,
    buttonTooltip: string,
    buttonIcon: string,
    widgetId: string,
    widgetTitle: string,
    backendUrl: string,
    healthPath: string,
}

local pluginConfiguration: PluginConfiguration = table.freeze({
    toolbarName = "Roblox AI",
    buttonId = "RobloxAI.ToggleWidget",
    buttonText = "Roblox AI",
    buttonTooltip = "Open the Roblox AI assistant",
    buttonIcon = "",
    widgetId = "RobloxAI.MainWidget",
    widgetTitle = "Roblox AI",
    backendUrl = "http://127.0.0.1:8765",
    healthPath = "/health",
})

return table.freeze({
    Plugin = pluginConfiguration,
})
