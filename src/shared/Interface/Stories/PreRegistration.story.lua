local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

_G.__DEV__ = RunService:IsStudio()

local Packages = ReplicatedStorage.Packages
local Quark = require(ReplicatedStorage.CoreLibs.Quark)
local React = require(Packages:WaitForChild("React"))
local ReactRoblox = require(Packages:WaitForChild("ReactRoblox"))
local InterfaceTypes = require("../../Common/Types/Interface")
local InterfaceManager = require(ReplicatedStorage.Shared.Controllers.InterfaceManager)

Quark.LoadMockedServicesDeep(ReplicatedStorage.Shared.MockedServices)

local Component = require(`../{script.Name:gsub(".story", "")}`) :: InterfaceTypes.Interface<any>
InterfaceManager:init()

return {
	react = React,
	reactRoblox = ReactRoblox,

	story = function(props)
		return React.createElement(function()
			return React.createElement(Component.func, {
				interfaceId = "test",
			})
		end)
	end,
}
