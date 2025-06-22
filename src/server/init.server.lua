--!native
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Novus = require(ReplicatedStorage.CoreLibs.Novus)
local RateLimiter = require(ReplicatedStorage.CoreLibs.RateLimiter)
local Quark = require(ReplicatedStorage.CoreLibs.Quark)

RateLimiter.start()

local Services = ServerScriptService.Server.Services
-- Entrypoint

Novus.createCache("api")
Quark.LoadServicesDeep(Services)
