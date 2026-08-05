--!strict

local WidgetView = {}
WidgetView.__index = WidgetView

export type ConnectionStatus = "disconnected" | "connecting" | "connected" | "error"

type StatusPresentation = {
    label: string,
    detail: string,
    color: Color3,
}

local STATUS_PRESENTATION: { [ConnectionStatus]: StatusPresentation } = table.freeze({
    disconnected = table.freeze({
        label = "Disconnected",
        detail = "No backend session is active.",
        color = Color3.fromRGB(151, 161, 176),
    }),
    connecting = table.freeze({
        label = "Connecting",
        detail = "Opening a backend session.",
        color = Color3.fromRGB(245, 184, 65),
    }),
    connected = table.freeze({
        label = "Connected",
        detail = "The backend session is available.",
        color = Color3.fromRGB(67, 194, 120),
    }),
    error = table.freeze({
        label = "Connection error",
        detail = "Check the backend and Studio HTTP permission.",
        color = Color3.fromRGB(239, 96, 96),
    }),
})

export type View = typeof(setmetatable(
    {} :: {
        _root: Frame,
        _statusDot: Frame,
        _statusLabel: TextLabel,
        _statusDetail: TextLabel,
        _refreshButton: TextButton,
    },
    WidgetView
))

local function createLabel(parent: Instance, name: string): TextLabel
    local label = Instance.new("TextLabel")
    label.Name = name
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(224, 229, 238)
    label.TextSize = 14
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

function WidgetView.new(parent: Instance, backendUrl: string): View
    local root = Instance.new("Frame")
    root.Name = "Root"
    root.BackgroundColor3 = Color3.fromRGB(27, 31, 40)
    root.BorderSizePixel = 0
    root.Size = UDim2.fromScale(1, 1)

    local title = createLabel(root, "Title")
    title.Font = Enum.Font.GothamBold
    title.Position = UDim2.fromOffset(20, 18)
    title.Size = UDim2.new(1, -40, 0, 28)
    title.Text = "Roblox AI"
    title.TextColor3 = Color3.fromRGB(245, 247, 250)
    title.TextSize = 22

    local subtitle = createLabel(root, "Subtitle")
    subtitle.Position = UDim2.fromOffset(20, 48)
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Text = "Studio assistant"
    subtitle.TextColor3 = Color3.fromRGB(151, 161, 176)
    subtitle.TextSize = 13

    local endpointCard = Instance.new("Frame")
    endpointCard.Name = "BackendEndpoint"
    endpointCard.BackgroundColor3 = Color3.fromRGB(35, 40, 51)
    endpointCard.BorderSizePixel = 0
    endpointCard.Position = UDim2.fromOffset(20, 88)
    endpointCard.Size = UDim2.new(1, -40, 0, 70)
    endpointCard.Parent = root

    local endpointCorner = Instance.new("UICorner")
    endpointCorner.CornerRadius = UDim.new(0, 8)
    endpointCorner.Parent = endpointCard

    local endpointHeading = createLabel(endpointCard, "Heading")
    endpointHeading.Font = Enum.Font.GothamMedium
    endpointHeading.Position = UDim2.fromOffset(16, 8)
    endpointHeading.Size = UDim2.new(1, -32, 0, 20)
    endpointHeading.Text = "Backend"
    endpointHeading.TextColor3 = Color3.fromRGB(188, 196, 209)
    endpointHeading.TextSize = 12

    local endpointValue = createLabel(endpointCard, "Url")
    endpointValue.Position = UDim2.fromOffset(16, 31)
    endpointValue.Size = UDim2.new(1, -32, 0, 24)
    endpointValue.Text = backendUrl
    endpointValue.TextColor3 = Color3.fromRGB(126, 174, 255)
    endpointValue.TextSize = 13

    local statusCard = Instance.new("Frame")
    statusCard.Name = "ConnectionStatus"
    statusCard.BackgroundColor3 = Color3.fromRGB(35, 40, 51)
    statusCard.BorderSizePixel = 0
    statusCard.Position = UDim2.fromOffset(20, 174)
    statusCard.Size = UDim2.new(1, -40, 0, 108)
    statusCard.Parent = root

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = statusCard

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(55, 62, 77)
    cardStroke.Thickness = 1
    cardStroke.Parent = statusCard

    local statusHeading = createLabel(statusCard, "Heading")
    statusHeading.Font = Enum.Font.GothamMedium
    statusHeading.Position = UDim2.fromOffset(16, 12)
    statusHeading.Size = UDim2.new(1, -32, 0, 22)
    statusHeading.Text = "Connection"
    statusHeading.TextColor3 = Color3.fromRGB(188, 196, 209)
    statusHeading.TextSize = 12

    local statusDot = Instance.new("Frame")
    statusDot.Name = "Indicator"
    statusDot.BorderSizePixel = 0
    statusDot.Position = UDim2.fromOffset(16, 45)
    statusDot.Size = UDim2.fromOffset(10, 10)
    statusDot.Parent = statusCard

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = statusDot

    local statusLabel = createLabel(statusCard, "State")
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.Position = UDim2.fromOffset(36, 37)
    statusLabel.Size = UDim2.new(1, -52, 0, 26)
    statusLabel.TextSize = 14

    local statusDetail = createLabel(statusCard, "Detail")
    statusDetail.Position = UDim2.fromOffset(16, 70)
    statusDetail.Size = UDim2.new(1, -32, 0, 22)
    statusDetail.TextColor3 = Color3.fromRGB(151, 161, 176)
    statusDetail.TextSize = 12

    local refreshButton = Instance.new("TextButton")
    refreshButton.Name = "Refresh"
    refreshButton.AutoButtonColor = true
    refreshButton.BackgroundColor3 = Color3.fromRGB(54, 106, 214)
    refreshButton.BorderSizePixel = 0
    refreshButton.Font = Enum.Font.GothamMedium
    refreshButton.Position = UDim2.fromOffset(20, 302)
    refreshButton.Size = UDim2.new(1, -40, 0, 38)
    refreshButton.Text = "Refresh"
    refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshButton.TextSize = 14
    refreshButton.Parent = root

    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshButton

    local permissionNotice = createLabel(root, "PermissionNotice")
    permissionNotice.Position = UDim2.fromOffset(20, 352)
    permissionNotice.Size = UDim2.new(1, -40, 0, 36)
    permissionNotice.Text = "Studio may ask permission before the first local HTTP request."
    permissionNotice.TextColor3 = Color3.fromRGB(126, 137, 154)
    permissionNotice.TextSize = 11
    permissionNotice.TextYAlignment = Enum.TextYAlignment.Top

    root.Parent = parent

    return setmetatable({
        _root = root,
        _statusDot = statusDot,
        _statusLabel = statusLabel,
        _statusDetail = statusDetail,
        _refreshButton = refreshButton,
    }, WidgetView)
end

function WidgetView.setRefreshEnabled(self: View, enabled: boolean): ()
    self._refreshButton.Active = enabled
    self._refreshButton.AutoButtonColor = enabled
    self._refreshButton.Text = if enabled then "Refresh" else "Refreshing..."
end

function WidgetView.onRefresh(self: View, callback: () -> ()): RBXScriptConnection
    return self._refreshButton.MouseButton1Click:Connect(callback)
end

function WidgetView.setConnectionStatus(self: View, status: ConnectionStatus): ()
    local presentation = STATUS_PRESENTATION[status]
    self._statusDot.BackgroundColor3 = presentation.color
    self._statusLabel.Text = presentation.label
    self._statusDetail.Text = presentation.detail
end

function WidgetView.destroy(self: View): ()
    self._root:Destroy()
end

return WidgetView
