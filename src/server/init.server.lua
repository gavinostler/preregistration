--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RateLimiter = require(ReplicatedStorage.CoreLibs.RateLimiter)
local Quark = require(ReplicatedStorage.CoreLibs.Quark)

RateLimiter.start()

local Services = ServerScriptService.Server.Services
-- Entrypoint

Quark.LoadServicesDeep(Services)

print(require(ServerScriptService.Server.Services.Register).getPreregisterCount():await())
