--!strict

local WidgetView = require(script.Parent.UI.WidgetView)
local HttpService = game:GetService("HttpService")

local Controller = {}
Controller.__index = Controller

export type Configuration = {
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

export type Controller = typeof(setmetatable(
    {} :: {
        _plugin: Plugin,
        _configuration: Configuration,
        _toolbar: PluginToolbar?,
        _widget: DockWidgetPluginGui?,
        _view: WidgetView.View?,
        _connections: { RBXScriptConnection },
        _started: boolean,
    },
    Controller
))

function Controller.new(pluginInstance: Plugin, configuration: Configuration): Controller
    local self = setmetatable({
        _plugin = pluginInstance,
        _configuration = configuration,
        _toolbar = nil,
        _widget = nil,
        _view = nil,
        _connections = {},
        _started = false,
    }, Controller)

    return self
end

function Controller._refreshConnection(self: Controller, view: WidgetView.View): ()
    if self._view ~= view then
        return
    end

    view:setConnectionStatus("connecting")
    view:setRefreshEnabled(false)

    task.spawn(function()
        local success = pcall(function()
            HttpService:GetAsync(self._configuration.backendUrl .. self._configuration.healthPath)
        end)

        if self._view ~= view then
            return
        end

        if success then
            view:setConnectionStatus("connected")
        else
            view:setConnectionStatus("error")
        end
        view:setRefreshEnabled(true)
    end)
end

function Controller.start(self: Controller): ()
    if self._started then
        return
    end

    local configuration = self._configuration
    local toolbar = self._plugin:CreateToolbar(configuration.toolbarName)
    local button = toolbar:CreateButton(
        configuration.buttonId,
        configuration.buttonTooltip,
        configuration.buttonIcon,
        configuration.buttonText
    )
    button.ClickableWhenViewportHidden = true

    local widgetInfo =
        DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Right, false, false, 380, 440, 320, 380)
    local widget = self._plugin:CreateDockWidgetPluginGuiAsync(configuration.widgetId, widgetInfo)
    widget.Title = configuration.widgetTitle

    local view = WidgetView.new(widget, configuration.backendUrl)
    view:setConnectionStatus("disconnected")

    self._toolbar = toolbar
    self._widget = widget
    self._view = view
    self._started = true

    table.insert(
        self._connections,
        button.Click:Connect(function()
            widget.Enabled = not widget.Enabled
        end)
    )
    table.insert(
        self._connections,
        widget:GetPropertyChangedSignal("Enabled"):Connect(function()
            button:SetActive(widget.Enabled)
        end)
    )
    table.insert(
        self._connections,
        view:onRefresh(function()
            self:_refreshConnection(view)
        end)
    )
    table.insert(
        self._connections,
        self._plugin.Unloading:Connect(function()
            self:destroy()
        end)
    )

    button:SetActive(widget.Enabled)
end

function Controller.destroy(self: Controller): ()
    if not self._started then
        return
    end

    for _, connection in self._connections do
        connection:Disconnect()
    end
    table.clear(self._connections)

    if self._view ~= nil then
        self._view:destroy()
        self._view = nil
    end

    if self._widget ~= nil then
        self._widget:Destroy()
        self._widget = nil
    end

    if self._toolbar ~= nil then
        self._toolbar:Destroy()
        self._toolbar = nil
    end

    self._started = false
end

return Controller
