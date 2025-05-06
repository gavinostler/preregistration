local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Quark = require(ReplicatedStorage.CoreLibs.Quark)
local Controllers = ReplicatedStorage.Shared.Controllers
-- Entrypoint

Quark.LoadControllersDeep(Controllers)

local InterfaceManager = require(ReplicatedStorage.Shared.Controllers.InterfaceManager)
local Interface = require(ReplicatedStorage.Shared.Interface.LoadingScreen)
local Modal = require(ReplicatedStorage.Shared.Interface.PreRegistration)

InterfaceManager:init()
InterfaceManager:displayInterface(Interface)
InterfaceManager:displayInterface(Modal)

game.SoundService.music:Play()
