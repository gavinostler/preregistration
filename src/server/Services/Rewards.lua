--!native
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Novus = require(ReplicatedStorage.CoreLibs.Novus)
local Quark = require(ReplicatedStorage.CoreLibs.Quark)
local promise = require(ReplicatedStorage.CoreLibs.Promise)
local rl = require(ReplicatedStorage.CoreLibs.RateLimiter)

local http = require("../Utility/HTTP")
local ApiTypes = require(ReplicatedStorage.Shared.Common.Types.API.Rewards)

local Service = {
	[Quark.ServiceOptions] = {
		Name = "Rewards",
	},
	endpoints = {},
}

local cache = Novus.getCache("api") :: Novus.NovusCache<any>

function Service.getCanClaim(userId)
	return promise.new(function(resolve, reject)
		local cached = cache:get(`next_claim_at:{userId}`)
		if cached then
			return resolve(cached :: ApiTypes.RewardsResponse)
		end

		http.makeRequest(`/v1/pd/users/{userId}/preregister/can_claim/`, {
			method = "GET",
		})
			:andThen(function(result: ApiTypes.LastClaimResponse)
				local refreshTime = 60 * 10
				if result.next_claim_at then
					local nextClaimAt = DateTime.fromIsoDate(result.next_claim_at)
					if nextClaimAt.UnixTimestamp > os.time() + refreshTime then
						refreshTime = nextClaimAt.UnixTimestamp - os.time()
					end
				end

				cache:set(`next_claim_at:{userId}`, result, { expiry = refreshTime }) -- Cache for 10 minutes
				return resolve(result)
			end, function(err)
				return reject(err)
			end)
			:await()
	end)
end

Service.endpoints.getCanClaim = rl.limit(function(self: Service, res, rej, user)
	self.getCanClaim(user.UserId):andThen(res, rej)
end, 30)

function Service.getRewards()
	return promise.new(function(resolve, reject)
		local cached = cache:get("rewards")
		if cached then
			return resolve(cached :: ApiTypes.RewardsResponse)
		end

		http.makeRequest(`/v1/pd/preregister/rewards/`, {
			method = "GET",
		})
			:andThen(function(result: ApiTypes.RewardsResponse)
				cache:set("rewards", result, { expiry = 60 * 30 }) -- Cache for 30 minutes
				return resolve(result)
			end, function(err)
				return reject(err)
			end)
			:await()
	end)
end

Service.endpoints.getRewards = rl.limit(function(self: Service, res, rej)
	self.getRewards():andThen(res, rej)
end, 10)

function Service.claimReward(userId: number)
	return promise.new(function(resolve, reject)
		http.makeRequest(`/v1/pd/users/{userId}/preregister/claim`, {
			method = "POST",
		})
			:andThen(function(result: ApiTypes.ClaimRewardResponse)
				cache:set(
					`next_claim_at:{userId}`,
					{ day = result.day, can_claim = false, next_claim_at = result.next_claim_at } :: ApiTypes.LastClaimResponse,
					{ expiry = 60 * 10 }
				)
				return resolve(result)
			end, function(err)
				return reject(err)
			end)
			:await()
	end)
end

Service.endpoints.claimReward = rl.limit(function(self: Service, res, rej, user: Player)
	self.claimReward(user.UserId):andThen(res, rej)
end, 2)

type Service = typeof(Service)

return Service
