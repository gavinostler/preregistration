local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Quark = require(ReplicatedStorage.CoreLibs.Quark)
local Controllers = ReplicatedStorage.Shared.Controllers
-- Entrypoint

Quark.LoadControllersDeep(Controllers)

local InterfaceManager = require(ReplicatedStorage.Shared.Utility.InterfaceManager)
local Interface = require(ReplicatedStorage.Shared.Interface.Modal)
local Interface2 = require(ReplicatedStorage.Shared.Interface.Test)

InterfaceManager:init()
InterfaceManager:displayInterface(Interface)
InterfaceManager:displayInterface(Interface2, {})
