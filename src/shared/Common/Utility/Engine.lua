--!native
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local EventHook = require(ReplicatedStorage.Shared.Common.Hooks.EventHook)

local utility = {}

function utility.scaleWithScreenSize(number: number, original: number)
	return number / original
end

function utility.ViewportSizeHook()
	local size, setSize = React.useState(workspace.CurrentCamera.ViewportSize)
	EventHook(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
		setSize(workspace.CurrentCamera.ViewportSize)
	end)
	return size
end

return utility
