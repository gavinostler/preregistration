--[[

❖ Quark is service and client manager in charge of replacing Knit as a whole, while providing types.

Any and all modules

]]

-- Imports
local RunService = game:GetService("RunService")

if RunService:IsServer() then
	return require(script.Server)
else
	return require(script.Client)
end
