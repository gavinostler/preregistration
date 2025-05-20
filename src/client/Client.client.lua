local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Quark = require(ReplicatedStorage.CoreLibs.Quark)
local InterfaceManager = require(ReplicatedStorage.Shared.Controllers.InterfaceManager)
local Interface = require(ReplicatedStorage.Shared.Interface.LoadingScreen)
local Modal = require(ReplicatedStorage.Shared.Interface.PreRegistration)

InterfaceManager:init()
InterfaceManager:displayInterface(Interface)
InterfaceManager:displayInterface(Modal)

local Controllers = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Controllers")
-- Entrypoint

Quark.LoadControllersDeep(Controllers)
game.SoundService.music:Play()
