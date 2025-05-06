local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

_G.__DEV__ = RunService:IsStudio()

local Packages = ReplicatedStorage.Packages
local React = require(Packages:WaitForChild("React"))
local ReactRoblox = require(Packages:WaitForChild("ReactRoblox"))
local InterfaceTypes = require("../../Common/Types/Interface")
local Component = require(`../{script.Name:gsub(".story", "")}`) :: InterfaceTypes.Interface<any>

return {
	react = React,
	reactRoblox = ReactRoblox,

	story = function(props)
		return React.createElement(Component.func, props.controls)
	end,
}
