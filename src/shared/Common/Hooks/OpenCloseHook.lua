--!native
--!strict

local InterfaceManager = require("../../Utility/InterfaceManager")
local OpenConstructor = require("../Utility/OpenConstructor")

--[[
    Returns a function that will hide the current UI.
]]
return OpenConstructor(function(interfaceId: string)
	InterfaceManager:closeInterface(interfaceId)
end)
