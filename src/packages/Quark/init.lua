--[[

❖ Quark is service and client manager in charge of replacing Knit as a whole, while providing types.

Any and all modules

]]

-- Imports
local RunService = game:GetService("RunService")

export type ServerResponse<T> = {
	success: boolean,
	data: T | string,
}

if RunService:IsServer() and RunService:IsRunning() == true then
	return require(script.Server)
else
	return require(script.Client)
end
