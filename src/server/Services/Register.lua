--!native
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Quark = require(ReplicatedStorage.CoreLibs.Quark)
local promise = require(ReplicatedStorage.CoreLibs.Promise)
local rl = require(ReplicatedStorage.CoreLibs.RateLimiter)

local http = require("../Utility/HTTP")
local ApiTypes = require(ReplicatedStorage.Shared.Common.Types.API.Preregister)

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
			:andThen(function(result: ApiTypes.PreregisterCountResponse)
				resolve(result)
			end, function(err)
				reject(err)
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
			:andThen(function(result: ApiTypes.PreregisterResponse)
				return resolve(result)
			end, function(err)
				return reject(err)
			end)
			:await()
	end)
end

Service.endpoints.preregister = rl.limit(function(self: Service, res, rej, user: Player)
	self.preregister(user.UserId):andThen(res, rej)
end, 2)

function Service.endpoints.getUserCount(self: Service, res, rej, user: Player)
	self.getPreregisterCount():andThen(res, rej)
end

type Service = typeof(Service)

return Service
