--!strict

local root = script.Parent.Parent
local Constants = require(root.Shared.Constants)
local PluginController = require(script.Parent.PluginController)

local controller = PluginController.new(plugin, Constants.Plugin)
controller:start()
