--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Quark = require(ReplicatedStorage.CoreLibs.Quark)
local promise = require(ReplicatedStorage.CoreLibs.Promise)
local rl = require(ReplicatedStorage.CoreLibs.RateLimiter)

local http = require("../Utility/HTTP")

local Service = {
	[Quark.ServiceOptions] = {
		Name = "Register",
	},
	endpoints = {},
}

function Service.getPreregisterCount()
	return promise.new(function(resolve, reject)
		http.makeRequest("/v1/pd/preregister/count", {
			method = "GET",
		})
			:andThen(function(result: { count: number })
				resolve(result.count)
			end, function(err)
				reject(err.status)
			end)
			:await()
	end)
end

function Service.preregister(userId: number)
	return promise.new(function(resolve, reject)
		http.makeRequest("/v1/pd/preregister/", {
			method = "POST",
			body = {
				user_id = userId,
			},
		})
			:andThen(function(result: { message: string })
				return resolve(result.message)
			end, function(err)
				return reject(err.status)
			end)
			:await()
	end)
end

Service.endpoints.preregister = rl.limit(function(self: Service, res, rej, user: Player)
	local success, count: string = self.preregister(user.UserId):await()
	if not success then
		rej(count)
	else
		res(count)
	end
end, 2)

function Service.endpoints.getUserCount(self: Service, res, rej, user: Player)
	local success, count = self.getPreregisterCount():await()
	if not success then
		rej(count)
	else
		res(count)
	end
end

type Service = typeof(Service)

return Service
