--!native
--!strict
local RunService = game:GetService("RunService")

local RateLimiter = {
	Limits = {} :: { [string]: number },
}

function RateLimiter.limit(f: (...any) -> ...any, requestsPerMinute: number)
	return function(self, res, rej, user: Player, ...)
		local key = tostring(user.UserId) .. "." .. tostring(f)
		if RateLimiter.Limits[key] == nil then
			RateLimiter.Limits[key] = 0
		end

		if RateLimiter.Limits[key] > requestsPerMinute then
			return rej("RATE_LIMITED")
		end

		RateLimiter.Limits[key] += 1

		return f(self, res, rej, user, ...)
	end
end

function RateLimiter.start()
	local t = 0
	RunService.Heartbeat:Connect(function(a0: number)
		t += a0
		if t > 60 then
			t = 0
			RateLimiter.Limits = {}
		end
	end)
end

return RateLimiter
