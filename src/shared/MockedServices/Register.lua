local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.CoreLibs.Promise)
local Quark = require(ReplicatedStorage.CoreLibs.Quark)

return {
	[Quark.ServiceOptions] = {
		Name = "Register",
	},

	preregister = function(self: any, userId: number)
		return Promise.new(function(resolve, reject)
			resolve({
				success = true,
				data = "WORKED",
			})
		end)
	end,

	getUserCount = function(self: any)
		return Promise.new(function(resolve, reject)
			resolve({
				success = true,
				data = 100,
			})
		end)
	end,
}
