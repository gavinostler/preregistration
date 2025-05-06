--!native
--!strict

local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))
local InterfaceManager = require(game.ReplicatedStorage.Shared.Controllers.InterfaceManager)

return function(interfaceId: string, f: () -> ())
	React.useEffect(function()
		InterfaceManager:setCloseFunction(interfaceId, f)
	end, {})

	return
end
