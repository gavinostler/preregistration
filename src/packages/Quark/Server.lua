--!native
--!strict

--[[

❖ Quark is service and client manager in charge of replacing Knit as a whole, while providing types.

Any and all modules

]]

-- Imports
local SYMBOLS = require(script.Parent.Symbols)
local TYPES = require(script.Parent.Types)

local ServerComm = require(script.Parent.Parent.Parent.Packages["_Index"]["sleitnick_comm@0.3.2"]["comm"]).ServerComm -- TODO: fix imports
local Promise = require(script.Parent.Parent.Promise)

local Quark = {
	__modules = {},
}

Quark.ServiceOptions, Quark.ControllerOptions = SYMBOLS.QUARK_MODULE_OPTIONS, SYMBOLS.QUARK_MODULE_OPTIONS

-- ❖ Services ❖ --

Quark.GetService = function(name: string)
	assert(Quark.__modules[name], string.format("Module %s does not exist.", name))

	return Quark.__modules[name]
end

Quark.LoadService = function(Module: { [any]: any })
	if typeof(Module) ~= "table" then
		return
	end

	if not Module[SYMBOLS.QUARK_MODULE_OPTIONS] then
		return
	end

	local ModuleOptions = Module[SYMBOLS.QUARK_MODULE_OPTIONS] :: TYPES.QUARK_MODULE_OPTIONS
	if not script.Parent:FindFirstChild("Services") then
		local folder = Instance.new("Folder", script.Parent)
		folder.Name = "Services"
	end
	local ServerComm = ServerComm.new(script.Parent.Services, ModuleOptions.Name)

	if Module.endpoints and typeof(Module.endpoints) == "table" then
		for key, value in Module.endpoints do
			if value == SYMBOLS.QUARK_SIGNAL_MARKER then
				Module.endpoints[key] = ServerComm:CreateSignal(key)
			elseif typeof(value) == "function" then
				ServerComm:BindFunction(key, function(...)
					local args = { ... } -- annoying workaround
					local success, data = Promise.new(function(resolve, reject)
						return Module.endpoints[key](Module, resolve, reject, unpack(args))
					end):await()

					if success == false and typeof(data) == "string" and data:len() > 50 then
						warn(data)
						return {
							success = success,
							data = "UNKNOWN_ERROR",
						} :: { data: any, success: boolean }
					end

					return {
						success = success,
						data = data,
					}
				end)
			end
		end
	end

	Module[SYMBOLS.QUARK_MODULE_COMMUNICATIONS] = ServerComm

	Quark.__modules[ModuleOptions.Name] = Module
end

Quark.LoadServicesDeep = function(group: Instance)
	for _, item in group:GetDescendants() do
		if not item:IsA("ModuleScript") then
			continue
		end

		Quark.LoadService(require(item) :: any)
	end
	for index, item in Quark.__modules do
		if not item.QuarkStart then
			continue
		end
		local success = pcall(function()
			item:QuarkStart()
		end)
		if not success then
			print(string.format("[QUARK] Module %s failed to load.", index))
		end
	end
end

Quark.CreateSignal = function()
	return SYMBOLS.QUARK_SIGNAL_MARKER
end

export type Quark = typeof(Quark)

return Quark
