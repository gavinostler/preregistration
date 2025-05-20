local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local InterfaceManager = require(script.Parent.InterfaceManager)
local Quark = require(ReplicatedStorage.CoreLibs.Quark)
local Modal = require(ReplicatedStorage.Shared.Interface.Modal)

local Controller = {
	[Quark.ControllerOptions] = {
		Name = "Player",
	},
}

function Controller.QuarkStart()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if input.KeyCode == Enum.KeyCode.V then
			InterfaceManager:displayInterface(Modal, {
				Text = "Version 0.0.1",
				Buttons = {
					{
						Text = "OK",
					},
				},
			})
		end

		if input.KeyCode == Enum.KeyCode.C then
			InterfaceManager:displayInterface(Modal, {
				Text = "Changelog for Version 0.0.1\n\n- Added this menu accessible by pressing C\n- Fixed the loading screen showing up but for a limited amount of time\n- Added translation, although disabled.",
				Buttons = {
					{
						Text = "OK",
					},
				},
			})
		end
	end)
end

return Controller
