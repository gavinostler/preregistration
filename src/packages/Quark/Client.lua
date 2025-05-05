--[[

❖ Quark is service and client manager in charge of replacing Knit as a whole, while providing types.

Any and all modules

]]

-- Imports
local Promise = require(script.Parent.Parent.Promise)
local SYMBOLS = require(script.Parent.Symbols)
local TYPES = require(script.Parent.Types)

local ClientComm = require(script.Parent.Parent.Parent.Packages["_Index"]["sleitnick_comm@0.3.2"]["comm"]).ClientComm -- todo fix imports

local Quark = {
	__modules = {},
	__services = {},
}

Quark.ServiceOptions, Quark.ControllerOptions = SYMBOLS.QUARK_MODULE_OPTIONS, SYMBOLS.QUARK_MODULE_OPTIONS

-- ❖ Controllers ❖ --

Quark.GetController = function(name: string)
	assert(Quark.__modules[name], string.format("Module %s does not exist.", name))

	return Quark.__modules[name]
end

Quark.GetService = function(name: string): any?
	if Quark.__services[name] then
		return Quark.__services[name]
	end

	if not script.Parent.Services:FindFirstChild(name) then
		return
	end

	local ClientComm = ClientComm.new(script.Parent.Services, true, name)
	local Service = ClientComm:BuildObject()
	Quark.__services[name] = Service
	warn("Service loading disabled")

	return Quark.GetService(name)
end

Quark.LoadController = function(Module)
	if typeof(Module) ~= "table" then
		return
	end

	if not Module[SYMBOLS.QUARK_MODULE_OPTIONS] then
		return
	end

	local ModuleOptions = Module[SYMBOLS.QUARK_MODULE_OPTIONS] :: TYPES.QUARK_MODULE_OPTIONS

	Quark.__modules[ModuleOptions.Name] = Module
end

Quark.LoadControllersDeep = function(group: Instance)
	for _, item in group:GetDescendants() do
		if not item:IsA("ModuleScript") then
			continue
		end

		Quark.LoadController(require(item) :: any)
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

Quark.Start = function()
	return Promise.new(function(resolve, reject: (...any) -> (), cancel: ((callback: (() -> ())?) -> boolean) -> ())
		while task.wait() do
			if script.Parent:FindFirstChild("Services") then
				resolve()
				break
			end
		end
	end)
end

export type Quark = typeof(Quark)

return Quark :: Quark
